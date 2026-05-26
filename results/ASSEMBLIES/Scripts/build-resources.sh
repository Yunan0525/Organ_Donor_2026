#!/bin/bash

. ../pipeline.source

cd $1
for s in `ls *.fna`
do
    conda activate bowtie-samtools
    bowtie2-build $s ${s::-4}
    samtools faidx $s
    conda deactivate

    conda activate picard
    picard CreateSequenceDictionary -R $s -O ${s::-4}.dict
    conda deactivate
done

mkdir -p ALL-PROT

for s in `ls *.fna`
do
    base=`basename $s`
    awk -f ../scripts/aux/gff-protein-list.awk DFAST/${base::-3}DFAST/genome.gff > ${base::-3}proteins.faa
done

cat *.proteins.faa > ALL-PROT/all-proteins.faa

for s in `ls *.fna`
do
    base=`basename $s`
    awk -f ../scripts/aux/gff-product-list.awk DFAST/${base::-3}DFAST/genome.gff
done > ALL-PROT/all-products.txt

cd ALL-PROT
conda activate diamond
diamond makedb --in all-proteins.faa -d all-proteins
diamond cluster -d all-proteins -o clusters.txt --approx-id 90 -M 7G
conda deactivate

cd ../..

