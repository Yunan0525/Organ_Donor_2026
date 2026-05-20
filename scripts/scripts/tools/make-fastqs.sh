#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=72g
#SBATCH -t 48:00:00

. ~/WGS/WGS.source

conda activate iss

iss generate --draft REFs/*.fna --abundance_file mean-abund.txt --cpus 16 --model NovaSeq --n_reads 20000000 -o NULL$1


