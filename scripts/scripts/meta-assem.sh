#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=240g
#SBATCH -t 96:00:00

. ./pipeline.source

mkdir -p $2/META-ASM/$1

OMP_NUM_THREADS=32

echo Start SPAdes
conda activate spades
spades.py -1 $2/FASTQs/$1_R1.fastq -2 $2/FASTQs/$1_R2.fastq \
    --meta -t 32 -m 240 -o $2/META-ASM/$1
conda deactivate
echo Complete SPAdes

awk -f scripts/aux/clip-contigs.awk $2/META-ASM/$1/contigs.fasta > $2/META-ASM/$1/contigs-clip.fna

echo Start initial DFAST
conda activate dfast
dfast --cpu 32 --genome $2/META-ASM/$1/contigs-clip.fna --out $2/META-ASM/$1/PRE-ANNOTATION --use_original_name t
conda deactivate
echo Complete initial DFAST

echo Start initial bowtie2 alignment
conda activate bowtie-samtools
cd $2/META-ASM/$1/PRE-ANNOTATION
bowtie2-build genome.fna genome
samtools faidx genome.fna
cd -

bowtie2 -x $2/META-ASM/$1/PRE-ANNOTATION/genome -1 $2/FASTQs/$1_R1.fastq -2 $2/FASTQs/$1_R2.fastq -p 32 -S $2/META-ASM/$1/PRE-ANNOTATION/$1.sam

samtools view -b -@ 32 -o $2/META-ASM/$1/PRE-ANNOTATION/$1.unsort.bam $2/META-ASM/$1/PRE-ANNOTATION/$1.sam
samtools sort -@ 32 -T $2/META-ASM/$1/PRE-ANNOTATION/$1 -o $2/META-ASM/$1/PRE-ANNOTATION/$1.bam $2/META-ASM/$1/PRE-ANNOTATION/$1.unsort.bam
samtools index -@ 32  $2/META-ASM/$1/PRE-ANNOTATION/$1.bam
rm $2/META-ASM/$1/PRE-ANNOTATION/$1.unsort.bam
rm $2/META-ASM/$1/PRE-ANNOTATION/$1.sam
conda deactivate
echo Complete initial bowtie2 alignment

gzip -9 -c $2/META-ASM/$1/PRE-ANNOTATION/genome.fna > $2/META-ASM/$1/PRE-ANNOTATION/genome.fna.gz
echo -e Taxon"\t"Fasta"\t"Sample"\t"BAM > $2/META-ASM/$1/PRE-ANNOTATION/resmico-map.txt
echo -e ${2}"\t"$2/META-ASM/$1/PRE-ANNOTATION/genome.fna.gz"\t"${1}"\t"$2/META-ASM/$1/PRE-ANNOTATION/${1}.bam >>\
     $2/META-ASM/$1/PRE-ANNOTATION/resmico-map.txt

echo Start ResMiCo
conda activate resmico
resmico bam2feat --outdir $2/META-ASM/$1/PRE-ANNOTATION/resmico-features --n-threads 32 \
	--tmpdir $2/META-ASM/$1/PRE-ANNOTATION/resmico-bam2feat_TMP \
	$2/META-ASM/$1/PRE-ANNOTATION/resmico-map.txt

resmico evaluate \
	--min-avg-coverage 10.0 \
	--save-path $2/META-ASM/$1/PRE-ANNOTATION/resmico-predictions \
	--save-name resmico-default-model \
	--feature-files-path $2/META-ASM/$1/PRE-ANNOTATION/resmico-features \
	--n-procs 1
conda deactivate

if [ -e $2/META-ASM/$1/PRE-ANNOTATION/resmico-predictions/resmico-default-model.csv ];
then
    echo ResMiCo success
else
    echo ResMiCo failed
    mkdir -p $2/META-ASM/$1/PRE-ANNOTATION/resmico-predictions
    echo 'cont_name,length,label,score,min,mean,std,max' > $2/META-ASM/$1/PRE-ANNOTATION/resmico-predictions/resmico-default-model.csv
fi
echo Complete ResMiCo

mkdir -p $2/META-ASM/$1/RESMICO
awk -f scripts/aux/filter-resmico.awk $2/META-ASM/$1/PRE-ANNOTATION/resmico-predictions/resmico-default-model.csv \
    $2/META-ASM/$1/PRE-ANNOTATION/genome.fna > $2/META-ASM/$1/RESMICO/contigs-resmico.fna

echo Start add Kraken2 and Blast taxa
conda activate kraken
kraken2 \
    --threads 32 \
    --db /work/users/r/o/roachjm/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB \
    --output $2/META-ASM/$1/RESMICO/$1.kraken.out \
    --report $2/META-ASM/$1/RESMICO/$1.kreport \
    $2/META-ASM/$1/RESMICO/contigs-resmico.fna
conda deactivate

awk -f scripts/aux/add-taxa-meta-asm.awk -vLABEL="_KR_" $2/META-ASM/$1/RESMICO/$1.kraken.out \
    $2/META-ASM/$1/RESMICO/contigs-resmico.fna > $2/META-ASM/$1/RESMICO/contigs-resmico-krakentaxa.fna
rm $2/META-ASM/$1/RESMICO/$1.kraken.out

conda activate blast
blastn -db /nas/longleaf/data/blast/nt -query $2/META-ASM/$1/RESMICO/contigs-resmico-krakentaxa.fna -num_threads 32 \
    -evalue 1.0E-50 -num_alignments 10 -perc_identity 0.90 -outfmt "6 std qcovs staxids" \
    -out $2/META-ASM/$1/RESMICO/$1.blast-hits.txt
conda deactivate

awk -f scripts/aux/filter-blast.awk $2/META-ASM/$1/RESMICO/$1.blast-hits.txt | \
    awk -f scripts/aux/add-taxa-meta-asm.awk -vLABEL="_BL_" - $2/META-ASM/$1/RESMICO/contigs-resmico-krakentaxa.fna \
	> $2/META-ASM/$1/RESMICO/contigs-resmico-krakentaxa-blasttaxa.fna
echo Complete add Kraken2 and Blast taxa

echo Start second bowtie2 alignment
conda activate bowtie-samtools
cd $2/META-ASM/$1/RESMICO
bowtie2-build contigs-resmico-krakentaxa-blasttaxa.fna contigs-resmico-krakentaxa-blasttaxa
samtools faidx contigs-resmico-krakentaxa-blasttaxa.fna
cd -

bowtie2 -x $2/META-ASM/$1/RESMICO/contigs-resmico-krakentaxa-blasttaxa \
	-1 $2/FASTQs/$1_R1.fastq -2 $2/FASTQs/$1_R2.fastq -p 32 -S $2/META-ASM/$1/RESMICO/$1.sam

samtools view -b -@ 32 -o $2/META-ASM/$1/RESMICO/$1.unsort.bam $2/META-ASM/$1/RESMICO/$1.sam
samtools sort -@ 32 -T $2/META-ASM/$1/RESMICO -o $2/META-ASM/$1/RESMICO/$1.bam $2/META-ASM/$1/RESMICO/$1.unsort.bam
samtools index -@ 32 $2/META-ASM/$1/RESMICO/$1.bam
conda deactivate
echo Complete second bowtie2 alignment

echo Start quantification
awk -f scripts/aux/quant-meta.awk -vLABEL=8 REFs/id-names.txt $2/META-ASM/$1/RESMICO/$1.sam > $2/META-ASM/$1/RESMICO/$1.kraken2.quant.txt
awk -f scripts/aux/quant-meta.awk -vLABEL=10 REFs/id-names.txt $2/META-ASM/$1/RESMICO/$1.sam > $2/META-ASM/$1/RESMICO/$1.blast.quant.txt
rm $2/META-ASM/$1.sam
echo End quantification

echo Start final DFAST
conda activate dfast
dfast --cpu 32 --genome $2/META-ASM/$1/RESMICO/contigs-resmico-krakentaxa-blasttaxa.fna \
      --out $2/META-ASM/$1/$1.ANNOTATION --use_original_name t
conda deactivate
echo Complete final DFAST

cp $2/META-ASM/$1/RESMICO/$1.kraken2.quant.txt $2/META-ASM/$1/$1.ANNOTATION
cp $2/META-ASM/$1/RESMICO/$1.blast.quant.txt $2/META-ASM/$1/$1.ANNOTATION

echo Start MetaQUAST
conda activate quast
REFs=`ls REFs/*.fna | tr '\n' ','`
metaquast.py $2/META-ASM/$1/$1.ANNOTATION/genome.fna --gene-finding -t 32 -o $2/META-ASM/$1/$1.ANNOTATION/METAQUAST -r ${REFs%?}
conda deactivate
echo Complete MetaQUAST

echo Start VAMB
mkdir -p $2/META-ASM/$1/VAMB
conda activate vamb
concatenate.py --keepnames $2/META-ASM/$1/VAMB/$1.catalogue.fna.gz $2/META-ASM/$1/$1.ANNOTATION/genome.fna 
minimap2 -d $2/META-ASM/$1/VAMB/$1.catalogue.mmi $2/META-ASM/$1/VAMB/$1.catalogue.fna.gz
minimap2 -t 32 -N 5 -ax sr $2/META-ASM/$1/VAMB/$1.catalogue.mmi --split-prefix mmsplit \
	 $2/FASTQs/$1_R1.fastq $2/FASTQs/$1_R2.fastq | \
    samtools sort -@ 32 -T $2/META-ASM/$1/VAMB | \
    samtools view -F 3584 -b -@ 32 > $2/META-ASM/$1/VAMB/$1.bam
vamb --outdir $2/META-ASM/$1/VAMB/VAMB-OUT --fasta $2/META-ASM/$1/VAMB/$1.catalogue.fna.gz \
     --bamfiles $2/META-ASM/$1/VAMB/$1.bam \
     --minfasta 200000 -t 128 #-t 128 for smaller number of contigs
conda deactivate
echo Complete VAMB
