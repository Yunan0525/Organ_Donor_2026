#!/bin/bash
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=32g
#SBATCH -t 24:00:00

. ./pipeline.source

OMP_NUM_THREADS=4

mkdir -p SNPs/$2/VC

conda activate bowtie-samtools
bowtie2 -x REFs/$2 -1 EXTRACTs/$2/FASTQs/$1_R1.fastq \
    -2 EXTRACTs/$2/FASTQs/$1_R2.fastq -p 4 -S SNPs/$2/VC/$1.sam
conda deactivate

conda activate picard
PICARD_PATH=/nas/longleaf/apps/picard/2.23.4/picard-2.23.4/
picard SortSam \
    -INPUT SNPs/$2/VC/$1.sam \
    -OUTPUT SNPs/$2/VC/$1.bam \
    -SORT_ORDER coordinate
rm SNPs/$2/VC/$1.sam
conda deactivate

conda activate qualimap
qualimap bamqc -nt 4 -bam SNPs/$2/VC/$1.bam -outdir SNPs/$2/VC/$1-QC
conda deactivate
