#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=96g
#SBATCH -t 36:00:00

. ./pipeline.source

mkdir -p $2/JOINs
mkdir -p $2/COMBINE
mkdir -p $2/TRIMMED
mkdir -p $2/HUMANN

OMP_NUM_THREADS=32

conda activate vsearch
echo Vsearch Begin
vsearch --threads 32 --fastq_qmax 90 --fastq_mergepairs $2/FASTQs/$1_R1.fastq \
    --reverse $2/FASTQs/$1_R2.fastq --fastqout $2/JOINs/$1_JOIN.fastq \
    --fastq_minovlen 60 --fastq_maxee 5.0 \
    --fastqout_notmerged_fwd $2/JOINs/$1_JOIN_R1.fastq \
    --fastqout_notmerged_rev $2/JOINs/$1_JOIN_R2.fastq
echo Vsearch Complete
conda deactivate

cat $2/JOINs/$1_JOIN_R1.fastq $2/JOINs/$1_JOIN_R2.fastq $2/JOINs/$1_JOIN.fastq \
    > $2/COMBINE/$1.fastq
rm $2/JOINs/$1_JOIN_R1.fastq $2/JOINs/$1_JOIN_R2.fastq $2/JOINs/$1_JOIN.fastq

conda activate trimgalore
trim_galore -j 6 $2/COMBINE/$1.fastq -o $2/TRIMMED
mv $2/TRIMMED/$1_trimmed.fq $2/TRIMMED/$1.fastq
rm $2/COMBINE/$1.fastq
conda deactivate

conda activate humann
humann --threads 32 --input $2/TRIMMED/$1.fastq --output $2/HUMANN/$1

mv $2/HUMANN/$1/$1_genefamilies.tsv $2/HUMANN/$1/$1_genefamilies-raw.tsv 

humann_rename_table -i $2/HUMANN/$1/$1_genefamilies-raw.tsv -n uniref90 \
    -o $2/HUMANN/$1/$1_genefamilies.tsv

humann_renorm_table --input $2/HUMANN/$1/$1_genefamilies.tsv \
    --output $2/HUMANN/$1/$1_genefamilies-cpm.tsv --units cpm --update-snames

humann_renorm_table --input $2/HUMANN/$1/$1_genefamilies.tsv \
    --output $2/HUMANN/$1/$1_genefamilies-relab.tsv --units relab --update-snames

humann_regroup_table --input $2/HUMANN/$1/$1_genefamilies.tsv \
    --output $2/HUMANN/$1/$1_ec.tsv -g uniref90_level4ec

cp $2/HUMANN/$1/$1_humann_temp/$1_metaphlan_bugs_list.tsv $2/HUMANN/$1/$1_metaphlan.tsv
#cp $2/HUMANN/$1/$1_humann_temp/$1_metaphlan_bowtie.txt $2/HUMANN/$1/$1_metaphlan_bowtie.txt
conda deactivate

rm -rf $2/HUMANN/$1/$1_humann_temp
rm $2/TRIMMED/$1.fastq

