#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=96g
#SBATCH -t 36:00:00

OMP_NUM_THREADS=32

. ./pipeline.source

mkdir -p QC0-NEW
conda activate fastqc
echo FastQC Initial Begin
fastqc -t 32 FASTQs/$1_R1_001.fastq.gz -o QC0-NEW
fastqc -t 32 FASTQs/$1_R2_001.fastq.gz -o QC0-NEW
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

mkdir -p QC1-NEW
conda activate fastqc
echo FastQC Post Trim Begin
fastqc -t 32 TRIMMED/$1_R1.fastq.gz -o QC1-NEW
fastqc -t 32 TRIMMED/$1_R2.fastq.gz -o QC1-NEW
echo FastQC Post Trim Complete
conda deactivate

mkdir -p KREPORTs-NEW
conda activate kraken
echo Kraken2 - Bracken Begin
kraken2 \
    --paired \
    --gzip-compressed \
    --threads 32 \
    --db /work/users/r/o/roachjm/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB \
    --output $1.kraken.out \
    --report KREPORTs-NEW/$1.kreport \
    TRIMMED/$1_R1.fastq.gz \
    TRIMMED/$1_R2.fastq.gz
echo Kraken2 Complete
conda deactivate

mkdir -p NON-HOST/FASTQs
zcat TRIMMED/$1_R1.fastq.gz | awk -f scripts/aux/remove-host.awk $1.kraken.out - \
    > NON-HOST/FASTQs/$1_R1.fastq
zcat TRIMMED/$1_R2.fastq.gz | awk -f scripts/aux/remove-host.awk $1.kraken.out - \
    > NON-HOST/FASTQs/$1_R2.fastq

rm TRIMMED/$1_R[1,2].fastq.gz
#rm $1.kraken.out
