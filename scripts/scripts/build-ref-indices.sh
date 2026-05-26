#!/bin/bash
#SBATCH -n 1
#SBATCH --mem=8g
#SBATCH -t 48:00:00

. ./pipeline.source

. ./Species.sh

cd REFs
for s in ${!SPECIES_IDS[@]}
do

    conda activate bowtie-samtools
    bowtie2-build $s.fna $s
    samtools faidx $s.fna
    conda deactivate

    conda activate picard
    picard CreateSequenceDictionary -R $s.fna -O $s.dict
    conda deactivate
    
    awk -f ../scripts/aux/groom-gff.awk $s.gff.orig > $s.gff
done

