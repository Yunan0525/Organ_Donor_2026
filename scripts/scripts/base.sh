#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=96g
#SBATCH -t 24:00:00

OMP_NUM_THREADS=32

. ./pipeline.source

mkdir -p QC0
conda activate fastqc
echo FastQC Initial Begin
fastqc -t 32 FASTQs/$1_R1_001.fastq.gz -o QC0
fastqc -t 32 FASTQs/$1_R2_001.fastq.gz -o QC0
echo FastQC Initial Complete
conda deactivate

mkdir -p TRIMMED
conda activate trimgalore
echo Trim-Galore Begin
trim_galore -j 6 --paired FASTQs/$1_R1_001.fastq.gz FASTQs/$1_R2_001.fastq.gz -o TRIMMED
mv TRIMMED/$1_R1_001_val_1.fq.gz TRIMMED/$1_R1.fastq.gz
mv TRIMMED/$1_R2_001_val_2.fq.gz TRIMMED/$1_R2.fastq.gz
echo Trim-Galore Complete
conda deactivate

mkdir -p QC1
conda activate fastqc
echo FastQC Post Trim Begin
fastqc -t 32 TRIMMED/$1_R1.fastq.gz -o QC1
fastqc -t 32 TRIMMED/$1_R2.fastq.gz -o QC1
echo FastQC Post Trim Complete
conda deactivate

mkdir -p KREPORTs
mkdir -p BRACKEN
conda activate kraken
echo Kraken2 - Bracken Begin
kraken2 \
    --paired \
    --gzip-compressed \
    --threads 32 \
    --db /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/ \
    --output $1.kraken.out \
    --report KREPORTs/$1.kreport \
    TRIMMED/$1_R1.fastq.gz \
    TRIMMED/$1_R2.fastq.gz
echo Kraken2 Complete

est_abundance.py \
    -i KREPORTs/$1.kreport \
    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
    -o BRACKEN/$1.bracken.out
echo Kraken2 - Bracken Complete
conda deactivate

mkdir -p EXTRACTs/UNK/FASTQs
zcat TRIMMED/$1_R1.fastq.gz | awk -vSS=0 -f scripts/aux/select.awk $1.kraken.out - \
    > EXTRACTs/UNK/FASTQs/$1_R1.fastq
zcat TRIMMED/$1_R2.fastq.gz | awk -vSS=0 -f scripts/aux/select.awk $1.kraken.out - \
    > EXTRACTs/UNK/FASTQs/$1_R2.fastq
sbatch -o LOGs/humann-UNK-${1}.%A.log scripts/humann-base.sh $1 EXTRACTs/UNK
sbatch -o LOGs/meta-assem-UNK-${1}.%A.log scripts/meta-assem.sh $1 EXTRACTs/UNK

mkdir -p NON-HOST/FASTQs
zcat TRIMMED/$1_R1.fastq.gz | awk -f scripts/aux/remove-host.awk $1.kraken.out - \
    > NON-HOST/FASTQs/$1_R1.fastq
zcat TRIMMED/$1_R2.fastq.gz | awk -f scripts/aux/remove-host.awk $1.kraken.out - \
    > NON-HOST/FASTQs/$1_R2.fastq
sbatch -o LOGs/humann-NON-HOST-${1}.%A.log scripts/humann-base.sh $1 NON-HOST

rm TRIMMED/$1_R[1,2].fastq.gz
rm $1.kraken.out
rm KREPORTs/$1_bracken_species.kreport
