#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=96g
#SBATCH -t 36:00:00

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
    --db /work/users/r/o/roachjm/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB \
    --output $1.kraken.out \
    --report KREPORTs/$1.kreport \
    TRIMMED/$1_R1.fastq.gz \
    TRIMMED/$1_R2.fastq.gz
echo Kraken2 Complete

est_abundance.py \
    -i KREPORTs/$1.kreport \
    -k /work/users/r/o/roachjm/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
    -o BRACKEN/$1.bracken.out
echo Kraken2 - Bracken Complete
conda deactivate

. ./Species.sh

for i in ${!SPECIES_IDS[@]}
do

    mkdir -p EXTRACTs/${i}/FASTQs
    echo ${i} ${SPECIES_IDS[$i]}
    zcat TRIMMED/$1_R1.fastq.gz | awk -vSS=${SPECIES_IDS[$i]} -f scripts/aux/select.awk $1.kraken.out - \
	> EXTRACTs/${i}/FASTQs/$1_R1.fastq
    zcat TRIMMED/$1_R2.fastq.gz | awk -vSS=${SPECIES_IDS[$i]} -f scripts/aux/select.awk $1.kraken.out - \
	> EXTRACTs/${i}/FASTQs/$1_R2.fastq

    READSx4=`wc -l EXTRACTs/${i}/FASTQs/$1_R1.fastq | cut -d' ' -f 1`
    if [ $READSx4 -ge 4000000 ]; then
	sbatch -o LOGs/hy-assem-${i}-${1}.%A.log scripts/hy-assem-refine-ann.sh $1 $i
	sbatch -o LOGs/algn-assem-${i}-${1}.%A.log scripts/algn-assem-refine-ann.sh $1 $i
	sbatch -o LOGs/denovo-assem-${i}-${1}.%A.log scripts/denovo-assem-refine-ann.sh $1 $i
    fi

    if [ $READSx4 -ge 40000 ]; then
	sbatch -o LOGs/vc-bcf-${i}-${1}.%A.log scripts/vc-bcf.sh $1 EXTRACTs/$i/FASTQs \
	       REFs/$i EXTRACTs/$i/VC-BCF
	sbatch -o LOGs/vc-${i}-${1}.%A.log scripts/vc.sh $1 $i
    fi

    if [ $READSx4 -ge 400 ]; then
	sbatch -o LOGs/humann-${i}-${1}.%A.log scripts/humann.sh $1 EXTRACTs/$i
    fi
    
done

mkdir -p EXTRACTs/Homo-sapiens/FASTQs
zcat TRIMMED/$1_R1.fastq.gz | awk -vSS=9606 -f scripts/aux/select.awk $1.kraken.out - \
				  > EXTRACTs/Homo-sapiens/FASTQs/$1_R1.fastq
zcat TRIMMED/$1_R2.fastq.gz | awk -vSS=9606 -f scripts/aux/select.awk $1.kraken.out - \
				  > EXTRACTs/Homo-sapiens/FASTQs/$1_R2.fastq

mkdir -p EXTRACTs/UNK/FASTQs
zcat TRIMMED/$1_R1.fastq.gz | awk -vSS=0 -f scripts/aux/select.awk $1.kraken.out - \
    > EXTRACTs/UNK/FASTQs/$1_R1.fastq
zcat TRIMMED/$1_R2.fastq.gz | awk -vSS=0 -f scripts/aux/select.awk $1.kraken.out - \
    > EXTRACTs/UNK/FASTQs/$1_R2.fastq
sbatch -o LOGs/humann-UNK-${1}.%A.log scripts/humann.sh $1 EXTRACTs/UNK
sbatch -o LOGs/meta-assem-UNK-${1}.%A.log scripts/meta-assem.sh $1 EXTRACTs/UNK

mkdir -p NON-HOST/FASTQs
zcat TRIMMED/$1_R1.fastq.gz | awk -f scripts/aux/remove-host.awk $1.kraken.out - \
    > NON-HOST/FASTQs/$1_R1.fastq
zcat TRIMMED/$1_R2.fastq.gz | awk -f scripts/aux/remove-host.awk $1.kraken.out - \
    > NON-HOST/FASTQs/$1_R2.fastq
sbatch -o LOGs/humann-NON-HOST-${1}.%A.log scripts/humann.sh $1 NON-HOST
#sbatch -o LOGs/meta-assem-NON-HOST-${1}.%A.log scripts/meta-assem-large.sh $1 NON-HOST

rm TRIMMED/$1_R[1,2].fastq.gz
#rm $1.kraken.out
rm KREPORTs/$1_bracken_species.kreport
