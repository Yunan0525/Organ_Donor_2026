#!/bin/bash
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=32g
#SBATCH -t 24:00:00

. ./pipeline.source

OMP_NUM_THREADS=4

mkdir -p EXTRACTs/$2/VC

unset DISPLAY

conda activate bowtie-samtools
echo Bowtie2 Begin
bowtie2 -x REFs/$2 -1 EXTRACTs/$2/FASTQs/$1_R1.fastq \
    -2 EXTRACTs/$2/FASTQs/$1_R2.fastq -p 4 -S EXTRACTs/$2/VC/$1.sam
echo Bowtie2 Complete
conda deactivate

conda activate picard
echo Picard 1 Begin
picard SortSam \
    -INPUT EXTRACTs/$2/VC/$1.sam \
    -OUTPUT EXTRACTs/$2/VC/$1.bam \
    -SORT_ORDER coordinate
rm EXTRACTs/$2/VC/$1.sam
echo Picard 1 Complete
conda deactivate

conda activate qualimap
echo QualiMap Begin
JAVA_OPTS="-Djava.awt.headless=true" qualimap bamqc -nt 4 -bam EXTRACTs/$2/VC/$1.bam -outdir EXTRACTs/$2/VC/$1-QC
echo QualiMap Complete
conda deactivate

conda activate picard
echo Picard 2 Begin
picard MarkDuplicates \
    -INPUT EXTRACTs/$2/VC/$1.bam \
    -OUTPUT EXTRACTs/$2/VC/$1.dm.bam \
    -METRICS_FILE EXTRACTs/$2/VC/$1-dm.metrics
rm EXTRACTs/$2/VC/$1.bam

picard AddOrReplaceReadGroups \
    -I EXTRACTs/$2/VC/$1.dm.bam \
    -O EXTRACTs/$2/VC/$1.rg.bam \
    -RGLB library \
    -RGPL illumina \
    -RGPU barcode \
    -RGSM sample
rm EXTRACTs/$2/VC/$1.dm.bam EXTRACTs/$2/VC/$1-dm.metrics
echo Picard 2 Complete
conda deactivate

conda activate bowtie-samtools
echo Samtools index Begin
samtools index EXTRACTs/$2/VC/$1.rg.bam
echo Samtools index Complete
conda deactivate

conda activate gatk
echo GATK Begin
gatk HaplotypeCaller  \
    -R REFs/$2.fna \
    -I EXTRACTs/$2/VC/$1.rg.bam \
    -O EXTRACTs/$2/VC/$1-raw.vcf.gz \
    --native-pair-hmm-threads 4

gatk SelectVariants \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw.vcf.gz \
    --select-type SNP \
    -O EXTRACTs/$2/VC/$1-raw-snps.vcf.gz

gatk SelectVariants \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw.vcf.gz \
    --select-type INDEL \
    -O EXTRACTs/$2/VC/$1-raw-indels.vcf.gz
rm EXTRACTs/$2/VC/$1-raw.vcf.gz EXTRACTs/$2/VC/$1-raw.vcf.gz.tbi

gatk VariantFiltration \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw-snps.vcf.gz \
    -O EXTRACTs/$2/VC/$1-filt-snps.vcf.gz \
    -filter-name "DP_filter" -filter "DP < 35.0" \
    -filter-name "QD_filter" -filter "QD < 2.0" \
    -filter-name "FS_filter" -filter "FS > 60.0" \
    -filter-name "MQ_filter" -filter "MQ < 30.0" \
    -filter-name "SOR_filter" -filter "SOR > 4.0"
rm EXTRACTs/$2/VC/$1-raw-snps.vcf.gz EXTRACTs/$2/VC/$1-raw-snps.vcf.gz.tbi

gatk SelectVariants \
    --exclude-filtered \
    -V EXTRACTs/$2/VC/$1-filt-snps.vcf.gz \
    -O EXTRACTs/$2/VC/$1-bqsr-snps.vcf.gz
rm EXTRACTs/$2/VC/$1-filt-snps.vcf.gz EXTRACTs/$2/VC/$1-filt-snps.vcf.gz.tbi

gatk VariantFiltration \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw-indels.vcf.gz \
    -O EXTRACTs/$2/VC/$1-filt-indels.vcf.gz \
    -filter-name "DP_filter" -filter "DP < 35.0" \
    -filter-name "QD_filter" -filter "QD < 2.0" \
    -filter-name "FS_filter" -filter "FS > 200.0" \
    -filter-name "SOR_filter" -filter "SOR > 10.0"
rm EXTRACTs/$2/VC/$1-raw-indels.vcf.gz EXTRACTs/$2/VC/$1-raw-indels.vcf.gz.tbi

gatk SelectVariants \
    --exclude-filtered \
    -V EXTRACTs/$2/VC/$1-filt-indels.vcf.gz \
    -O EXTRACTs/$2/VC/$1-bqsr-indels.vcf.gz
rm EXTRACTs/$2/VC/$1-filt-indels.vcf.gz EXTRACTs/$2/VC/$1-filt-indels.vcf.gz.tbi

gatk BaseRecalibrator \
    -R REFs/$2.fna \
    --known-sites EXTRACTs/$2/VC/$1-bqsr-snps.vcf.gz \
    --known-sites EXTRACTs/$2/VC/$1-bqsr-indels.vcf.gz \
    -I EXTRACTs/$2/VC/$1.rg.bam \
    -O EXTRACTs/$2/VC/$1.recal.table

gatk ApplyBQSR \
   -R REFs/$2.fna \
   -I EXTRACTs/$2/VC/$1.rg.bam \
   --bqsr-recal-file EXTRACTs/$2/VC/$1.recal.table \
   -O EXTRACTs/$2/VC/$1.recal.bam
rm EXTRACTs/$2/VC/$1.rg.bam EXTRACTs/$2/VC/$1.rg.bam.bai
rm EXTRACTs/$2/VC/$1-bqsr-snps.vcf.gz EXTRACTs/$2/VC/$1-bqsr-snps.vcf.gz.tbi
rm EXTRACTs/$2/VC/$1-bqsr-indels.vcf.gz EXTRACTs/$2/VC/$1-bqsr-indels.vcf.gz.tbi
rm EXTRACTs/$2/VC/$1.recal.table

gatk HaplotypeCaller  \
    -R REFs/$2.fna \
    -I EXTRACTs/$2/VC/$1.recal.bam \
    -O EXTRACTs/$2/VC/$1-raw.vcf.gz \
    --native-pair-hmm-threads 4 \
    -bamout EXTRACTs/$2/VC/$1.vcf.bam
rm EXTRACTs/$2/VC/$1.recal.bam EXTRACTs/$2/VC/$1.recal.bai

gatk SelectVariants \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw.vcf.gz \
    --select-type SNP \
    -O EXTRACTs/$2/VC/$1-raw-snps.vcf.gz

gatk SelectVariants \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw.vcf.gz \
    --select-type INDEL \
    -O EXTRACTs/$2/VC/$1-raw-indels.vcf.gz
rm EXTRACTs/$2/VC/$1-raw.vcf.gz EXTRACTs/$2/VC/$1-raw.vcf.gz.tbi

gatk VariantFiltration \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw-snps.vcf.gz \
    -O EXTRACTs/$2/VC/$1-filt-snps.vcf.gz \
    -filter-name "DP_filter" -filter "DP < 35.0" \
    -filter-name "QD_filter" -filter "QD < 2.0" \
    -filter-name "FS_filter" -filter "FS > 60.0" \
    -filter-name "MQ_filter" -filter "MQ < 30.0" \
    -filter-name "SOR_filter" -filter "SOR > 4.0"
rm EXTRACTs/$2/VC/$1-raw-snps.vcf.gz EXTRACTs/$2/VC/$1-raw-snps.vcf.gz.tbi

gatk SelectVariants \
    --exclude-filtered \
    -V EXTRACTs/$2/VC/$1-filt-snps.vcf.gz \
    -O EXTRACTs/$2/VC/$1-snps.vcf.gz
rm EXTRACTs/$2/VC/$1-filt-snps.vcf.gz EXTRACTs/$2/VC/$1-filt-snps.vcf.gz.tbi

gatk VariantFiltration \
    -R REFs/$2.fna \
    -V EXTRACTs/$2/VC/$1-raw-indels.vcf.gz \
    -O EXTRACTs/$2/VC/$1-filt-indels.vcf.gz \
    -filter-name "DP_filter" -filter "DP < 35.0" \
    -filter-name "QD_filter" -filter "QD < 2.0" \
    -filter-name "FS_filter" -filter "FS > 200.0" \
    -filter-name "SOR_filter" -filter "SOR > 10.0"
rm EXTRACTs/$2/VC/$1-raw-indels.vcf.gz EXTRACTs/$2/VC/$1-raw-indels.vcf.gz.tbi

gatk SelectVariants \
    --exclude-filtered \
    -V EXTRACTs/$2/VC/$1-filt-indels.vcf.gz \
    -O EXTRACTs/$2/VC/$1-indels.vcf.gz
rm EXTRACTs/$2/VC/$1-filt-indels.vcf.gz EXTRACTs/$2/VC/$1-filt-indels.vcf.gz.tbi
echo GATK Complete
conda deactivate

