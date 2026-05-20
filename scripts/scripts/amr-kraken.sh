#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=96g
#SBATCH -t 36:00:00

OMP_NUM_THREADS=32

. ./pipeline.source

mkdir -p NON-HOST/AMR-ALL/KREPORTs
mkdir -p NON-HOST/AMR-ALL/BRACKEN
conda activate kraken
echo Kraken2 - Bracken Begin
kraken2 \
    --paired \
    --threads 32 \
    --gzip-compressed \
    --db /work/users/r/o/roachjm/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB \
    --output NON-HOST/AMR-ALL/$1.kraken.out \
    --report NON-HOST/AMR-ALL/KREPORTs/$1.kreport \
    NON-HOST/AMR-ALL/FASTQs/$1_R1.fastq.gz \
    NON-HOST/AMR-ALL/FASTQs/$1_R2.fastq.gz
echo Kraken2 Complete

est_abundance.py \
    -i NON-HOST/AMR-ALL/KREPORTs/$1.kreport \
    -k /work/users/r/o/roachjm/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
    -o NON-HOST/AMR-ALL/BRACKEN/$1.bracken.out
echo Kraken2 - Bracken Complete
conda deactivate
