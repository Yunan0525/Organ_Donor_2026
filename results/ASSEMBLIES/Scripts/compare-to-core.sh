#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH --mem=96g
#SBATCH -t 96:00:00

. ../pipeline.source

awk -f scripts/aux/gff-protein-list.awk $1.gff > $1.proteins.faa

cat $2/ALL-PROT/all-proteins.faa $1.proteins.faa > ${1}+ALL.proteins.faa

conda activate diamond
diamond makedb --in ${1}+ALL.proteins.faa -d ${1}+ALL --threads 32
diamond cluster -d ${1}+ALL -o ${1}+ALL.clusters.txt --approx-id 97 \
	--memory-limit 90G --threads 32 
conda deactivate

awk -f scripts/aux/id-new-proteins.awk $1.proteins.faa ${1}+ALL.clusters.txt > $1.novel.txt

awk -f scripts/aux/extract-new-proteins.awk ${1}.novel.txt $1.proteins.faa > $1.novel.faa

# Use diamond with Blast lib capability
$HOME/bin/diamond blastp -d /work/users/r/o/roachjm/projects/BLASTDB/nr \
		  -q $1.novel.faa -o $1.matches.txt --threads 32

awk -f scripts/aux/filter-new-protein-hits.awk ${1}.matches.txt > ${1}.novel-matches.txt 

cut -f 2 $1.novel-matches.txt > $1.blast-names.txt

conda activate blast
blastdbcmd -entry_batch $1.blast-names.txt -db /work/users/r/o/roachjm/projects/BLASTDB/nr \
	   -outfmt "%i!%t!%T!%S" | tr "!" "\t" | sed 's/|\t/\t/g' | tr "|" "\t" |\
    awk -F"\t" '(NR==FNR) { keep[$1]=$1; } (NR!=FNR)&&($2 in keep)' $1.blast-names.txt - \
	> $1.novel-matches-2.txt
conda deactivate

rm ${1}+ALL.clusters.txt ${1}+ALL.proteins.faa ${1}+ALL.dmnd $1.proteins.faa \
   $1.matches.txt $1.blast-names.txt
