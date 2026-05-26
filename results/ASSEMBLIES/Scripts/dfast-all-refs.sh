#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=64g
#SBATCH -t 96:00:00

OMP_NUM_THREADS=32

. ../pipeline.source

mkdir -p $1/DFAST

conda activate dfast
for i in `ls $1/*.fna`
do
    base=`basename $i`
    dfast --cpu 32 --genome ${i} --out $1/DFAST/${base::-3}DFAST --use_original_name t
done
conda deactivate

