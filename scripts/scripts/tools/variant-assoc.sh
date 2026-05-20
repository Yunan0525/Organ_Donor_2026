#!/bin/bash

module add r/4.2.2

. ./Species.sh

for o in ${!SPECIES_IDS[@]}
do
    FILES=""
    for s in `tail -n +2 $1.samples.txt`
    do
	if [ -f EXTRACTs/${o}/VC-BCF/${s}-filtered.vcf.gz ]; then
	   FILES=$FILES" EXTRACTs/${o}/VC-BCF/${s}-filtered.vcf.gz"
	fi
    done

    if [ "$FILES" != "" ]; then
	zcat $FILES | awk -f scripts/tools/aux/merge-variants.awk - | sort -gk 2 |\
	    awk -f scripts/tools/aux/pre-fisher.awk $1.mapping.txt - | Rscript scripts/tools/aux/fisher.R |\
	    tr -d ' ' | sort -gk 1 | awk -F"\t" -vORG=$o '{ print ORG"\t"$0; }'
    fi
    
done
