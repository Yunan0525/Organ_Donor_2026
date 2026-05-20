#!/bin/bash

for i in `ls EXTRACTs`
do
    for j in `ls EXTRACTs/$i/CARD/*.vsearch.quant.txt`
    do
	if [ -e ${j/vsearch/diamond} ];then
	    #echo $j ${j/vsearch/diamond}
	    awk -f scripts/tools/aux/compare-vsearch-diamond.awk $j ${j/vsearch/diamond}
	fi
    done
done

for i in `ls NON-HOST/CARD/*.vsearch.quant.txt`
do
    if [ -e ${i/vsearch/diamond} ];then
	#echo $i ${i/vsearch/diamond}
	awk -f scripts/tools/aux/compare-vsearch-diamond.awk $i ${i/vsearch/diamond}
    fi
done
