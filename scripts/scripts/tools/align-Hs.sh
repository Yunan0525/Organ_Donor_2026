#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=64g
#SBATCH -t 24:00:00

OMP_NUM_THREADS=32

. ./pipeline.source

mkdir -p ${1}-Hs

conda activate bowtie-samtools

for i in `ls EXTRACTs/${1}/FASTQs/*_R1.fastq`
do
    base=`basename $i`
    echo ${base::-9}
    bowtie2 -x REFs/$1 -1 $i -2 ${i/R1/R2} \
	    -S /dev/null -p 32 --un-conc ${1}-Hs/${base::-9}-No${1} --al-conc ${1}-Hs/${base::-9}-${1} 2>&1 | grep overall
    echo No${1}-Hs
    bowtie2 -x /proj/seq/data/archives/bowtie2/hg19/hg19 -1 ${1}-Hs/${base::-9}-No${1}.1 -2 ${1}-Hs/${base::-9}-No${1}.2 \
	    -S /dev/null -p 32 2>&1 | grep overall
    echo ${1}-Hs
    bowtie2 -x /proj/seq/data/archives/bowtie2/hg19/hg19 -1 ${1}-Hs/${base::-9}-${1}.1 -2 ${1}-Hs/${base::-9}-${1}.2 \
	    -S /dev/null -p 32 2>&1 | grep overall

    rm ${1}-Hs/${base::-9}-No${1}.? ${1}-Hs/${base::-9}-${1}.?
done

conda deactivate
