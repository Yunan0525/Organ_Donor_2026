#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=32g
#SBATCH -t 96:00:00

. ./pipeline.source

mkdir -p NON-HOST/JOINs
mkdir -p NON-HOST/COMBINE
mkdir -p NON-HOST/TRIMMED
mkdir -p NON-HOST/CARD

OMP_NUM_THREADS=32

zcat NON-HOST/FASTQs/$1_R1.fastq.gz > NON-HOST/FASTQs/$1_R1.fastq
zcat NON-HOST/FASTQs/$1_R2.fastq.gz > NON-HOST/FASTQs/$1_R2.fastq

conda activate vsearch
echo Vsearch Begin
vsearch --threads 32 --fastq_qmax 90 --fastq_mergepairs NON-HOST/FASTQs/$1_R1.fastq \
    --reverse NON-HOST/FASTQs/$1_R2.fastq --fastqout NON-HOST/JOINs/$1_JOIN.fastq \
    --fastq_minovlen 60 --fastq_maxee 5.0 \
    --fastqout_notmerged_fwd NON-HOST/JOINs/$1_JOIN_R1.fastq \
    --fastqout_notmerged_rev NON-HOST/JOINs/$1_JOIN_R2.fastq
echo Vsearch Complete
conda deactivate

cat NON-HOST/JOINs/$1_JOIN_R1.fastq NON-HOST/JOINs/$1_JOIN_R2.fastq NON-HOST/JOINs/$1_JOIN.fastq \
    > NON-HOST/COMBINE/$1.fastq
rm NON-HOST/JOINs/$1_JOIN_R1.fastq NON-HOST/JOINs/$1_JOIN_R2.fastq NON-HOST/JOINs/$1_JOIN.fastq

conda activate trimgalore
echo Trim Begin
trim_galore -j 6 NON-HOST/COMBINE/$1.fastq -o NON-HOST/TRIMMED
mv NON-HOST/TRIMMED/$1_trimmed.fq NON-HOST/TRIMMED/$1.fastq
rm NON-HOST/COMBINE/$1.fastq
echo Trim Complete
conda deactivate

conda activate vsearch
echo VSearch CARD Begin
vsearch --fastq_filter NON-HOST/TRIMMED/$1.fastq --fastaout NON-HOST/TRIMMED/$1.fasta
vsearch --usearch_global NON-HOST/TRIMMED/$1.fasta --db REFs/CARD/nucleotide_fasta_protein_homolog_model.fasta \
	--blast6out NON-HOST/CARD/$1.vsearch.txt --id 0.99 --mincols 100 --threads 32
vsearch --usearch_global NON-HOST/TRIMMED/$1.fasta --db REFs/CARD/nucleotide_fasta_protein_homolog_model.fasta \
	--otutabout NON-HOST/CARD/$1.vsearch.quant.txt --id 0.99 --mincols 100 --threads 32
echo VSearch CARD Complete
conda deactivate

mkdir -p NON-HOST/AMR-FASTQs/$1
awk -f scripts/aux/select-vsearch-reads-nonhost.awk -vREAD="R1" -vSAMPLE=$1 NON-HOST/CARD/$1.vsearch.txt \
    NON-HOST/FASTQs/$1_R1.fastq
awk -f scripts/aux/select-vsearch-reads-nonhost.awk -vREAD="R2" -vSAMPLE=$1 NON-HOST/CARD/$1.vsearch.txt \
    NON-HOST/FASTQs/$1_R2.fastq

rm NON-HOST/TRIMMED/$1.fastq NON-HOST/TRIMMED/$1.fasta
rm NON-HOST/FASTQs/$1_R?.fastq
