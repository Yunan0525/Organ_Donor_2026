#!/bin/bash
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=16g
#SBATCH -t 24:00:00

. ./pipeline.source

mkdir -p $4

conda activate bowtie-samtools
bowtie2 -x $3 -1 $2/$1_R1.fastq \
    -2 $2/$1_R2.fastq -p 4 |\
    samtools view -S -b | samtools sort > $4/$1.bam
    
bcftools mpileup -f $3.fna -Oz9 $4/$1.bam > $4/$1.mpileup.vcf.gz

bcftools call --ploidy 1 -m -Oz9 $4/$1.mpileup.vcf.gz > $4/$1.vcf.gz

awk -vDEPTH=60 -vMAP_QUAL=20 -f scripts/aux/filter-vc-bcf.awk \
    <( zcat $4/$1.mpileup.vcf ) <( zcat $4/$1.vcf.gz ) \
    | bgzip -l 9 > $4/${1}-filtered.vcf.gz

conda deactivate

lines=`zcat $4/${1}-filtered.vcf.gz | grep -v '^#' | wc -l`
if [ $lines -eq 0 ]; then
    rm $4/${1}-filtered.vcf.gz
fi

rm $4/$1.mpileup.vcf.gz

#https://www.nature.com/articles/s41598-022-15563-2

#GATK
#Then, SNVs were collected from the resulting vcf file. Hard Filtering was performed with the following criterion: QD < 2, FS > 60, MQ < 40, MQRankSum < − 12.5, ReadPosRankSum < − 8.

#bcltools
#Variant calling was also performed using Bcftools v1.9 with ‘bcftools mpileup -f REFERENCE LIST_OF_BAM | bcftools call -mv -Oz -o VCFFILE’ command, where REFERENCE, LIST_OF_BAM, and VCFFILE are the name of the reference genome sequence, the list of bam files, and the resulting vcf file name, respectively. Then, only SNVs were collected. Filtering was performed by discarding SNVs in which the variant calling score at QUAL field is lower than 20.
