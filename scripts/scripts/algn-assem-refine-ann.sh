#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=64g
#SBATCH -t 24:00:00

OMP_NUM_THREADS=32

. ./pipeline.source

mkdir -p EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1

conda activate bowtie-samtools
echo Bowtie2 - Samtools - SeqTK Begin

bowtie2 -x REFs/$2 -1 EXTRACTs/$2/FASTQs/$1_R1.fastq \
    -2 EXTRACTs/$2/FASTQs/$1_R2.fastq --no-unal \
    -S EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.sam -p 32 \
    --un-conc EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-LEFTOVER

mv EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-LEFTOVER.1 EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-LEFTOVER_R1.fastq
mv EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-LEFTOVER.2 EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-LEFTOVER_R2.fastq

samtools view --threads 32 -bS EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.sam | samtools sort - \
    -o EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.bam --threads 32

bcftools mpileup --threads 32 -f REFs/$2.fna EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.bam |\
 bcftools call --threads 32 --ploidy 1 -c | vcfutils.pl vcf2fq > EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.scaf.fastq

seqtk seq -aQ64 -q20 -n N EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.scaf.fastq \
    > EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.scaf-0.fasta

awk -f scripts/aux/chop-scaffold.awk EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.scaf-0.fasta \
    > EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna
bowtie2-build EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip
samtools faidx EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna

rm EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.sam EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.bam
rm EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.scaf.fastq EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/$1-$2.scaf-0.fasta

echo Bowtie2 - Samtools - SeqTK Complete
conda deactivate

echo Call vc-bcf Begin
bash scripts/vc-bcf.sh $1 EXTRACTs/$2/FASTQs EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip EXTRACTs/$2/ALGN-ASM/VC-BCF
echo Call vc-bcf Complete

conda activate picard
echo Picard Build Dictionary
picard CreateSequenceDictionary \
    -R EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna \
    -O EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.dict
echo Picard Build Dictionary
conda deactivate

echo GATK Begin
conda activate gatk
mkdir -p EXTRACTs/$2/ALGN-ASM/REFINED/$1

if [ `zcat EXTRACTs/$2/ALGN-ASM/VC-BCF/${1}-filtered.vcf.gz | grep -v '^#' | wc -l` -gt 0 ]; then

    gatk IndexFeatureFile \
	 -I EXTRACTs/$2/ALGN-ASM/VC-BCF/${1}-filtered.vcf.gz
    
    gatk FastaAlternateReferenceMaker \
	-R EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna \
	--variant EXTRACTs/$2/ALGN-ASM/VC-BCF/${1}-filtered.vcf.gz \
	-O EXTRACTs/$2/ALGN-ASM/REFINED/$1/assembly.fna
else

    cp EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna EXTRACTs/$2/ALGN-ASM/REFINED/$1/assembly.fna

fi
echo GATK Complete
conda deactivate

conda activate quast
echo QUAST 1 Begin
if [ -f REFs/$2.gff ]; then

    quast.py EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna --gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/QUAST-ICARUS \
	-r REFs/$2.fna -g REFs/$2.gff 

    quast.py EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna -1 EXTRACTs/$2/FASTQs/$1_R1.fastq -2 EXTRACTs/$2/FASTQs/$1_R2.fastq \
	--gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/QUAST -r REFs/$2.fna -g REFs/$2.gff  --no-icarus

    quast.py EXTRACTs/$2/ALGN-ASM/REFINED/$1/assembly.fna --gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/REFINED/$1/QUAST-INITIAL \
	-r REFs/$2.fna -g REFs/$2.gff

else

    quast.py EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna --gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/QUAST-ICARUS \
	-r REFs/$2.fna

    quast.py EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/contigs-clip.fna -1 EXTRACTs/$2/FASTQs/$1_R1.fastq -2 EXTRACTs/$2/FASTQs/$1_R2.fastq \
	--gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ASSEMBLY/$1/QUAST -r REFs/$2.fna --no-icarus

    quast.py EXTRACTs/$2/ALGN-ASM/REFINED/$1/assembly.fna --gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/REFINED/$1/QUAST-INITIAL \
	-r REFs/$2.fna

fi
echo QUAST 1 Complete
conda deactivate

awk -f scripts/aux/remove-fully-unaligned.awk EXTRACTs/$2/ALGN-ASM/REFINED/$1/QUAST-INITIAL/contigs_reports/contigs_report_assembly.unaligned.info \
    EXTRACTs/$2/ALGN-ASM/REFINED/$1/assembly.fna > EXTRACTs/$2/ALGN-ASM/REFINED/$1/filtered-assembly.fna

mkdir -p EXTRACTs/$2/ALGN-ASM/ANNOTATION

conda activate dfast
echo DFAST Begin
dfast --cpu 32 --genome EXTRACTs/$2/ALGN-ASM/REFINED/$1/filtered-assembly.fna \
      --out EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1 \
      --use_original_name t
echo DFAST Complete
conda deactivate

conda activate quast
echo QUAST 2 Begin
if [ -f REFs/$2.gff ]; then

    quast.py EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/genome.fna --gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/QUAST-ICARUS \
	-r REFs/$2.fna -g REFs/$2.gff 

    quast.py EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/genome.fna -1 EXTRACTs/$2/FASTQs/$1_R1.fastq -2 EXTRACTs/$2/FASTQs/$1_R2.fastq \
	--gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/QUAST -r REFs/$2.fna -g REFs/$2.gff  --no-icarus

else

    quast.py EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/genome.fna --gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/QUAST-ICARUS \
	-r REFs/$2.fna

    quast.py EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/genome.fna -1 EXTRACTs/$2/FASTQs/$1_R1.fastq -2 EXTRACTs/$2/FASTQs/$1_R2.fastq \
	--gene-finding -t 32 -o EXTRACTs/$2/ALGN-ASM/ANNOTATION/$1/QUAST -r REFs/$2.fna --no-icarus

fi
echo QUAST 2 Complete
conda deactivate
