#!/bin/bash

# sh compare-ccrepe.sh LARGE.bracken-5000-20 SMALL.bracken-5000-20 Species-100k-100k.txt 

awk -f scripts/aux/linearize-ccrepe.awk $1.species.score.txt $1.species.qvalue.txt | tr -d '"' |\
   awk -f scripts/aux/trim-linear.awk $3 - > $1.linear.txt
awk -f scripts/aux/linearize-ccrepe.awk $2.species.score.txt $2.species.qvalue.txt | tr -d '"' |\
   awk -f scripts/aux/trim-linear.awk $3 - > $2.linear.txt
awk -f scripts/aux/compare-linear.awk $1.linear.txt $2.linear.txt | sort -t$'\t' -gk 3 | awk -F"\t" '($6<0.05)||($7<0.05)'

rm $1.linear.txt $2.linear.txt

