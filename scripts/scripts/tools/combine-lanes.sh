#!/bin/bash
#SBATCH -n 1
#SBATCH --mem=8g
#SBATCH -t 24:00:00

zcat FASTQsxLANE/${1}_L00?_R1_001.fastq.gz | gzip -9 > FASTQs/${1}_L001_R1_001.fastq.gz
zcat FASTQsxLANE/${1}_L00?_R2_001.fastq.gz | gzip -9 > FASTQs/${1}_L001_R2_001.fastq.gz
