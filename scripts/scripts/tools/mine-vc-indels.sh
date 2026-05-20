#!/bin/bash

. ./Species.sh

for o in ${!SPECIES_IDS[@]}
do
    for s in `tail -n +2 Samples.txt`
    do
	if [ -e EXTRACTs/$o/VC/$s-indels.vcf.gz ]; then
	    zcat EXTRACTs/$o/VC/$s-indels.vcf.gz | \
		awk -vTAG1=$o -vTAG2=$s -f scripts/tools/aux/join-vcf-gff.awk - REFs/$o.gff
	fi
    done
done
