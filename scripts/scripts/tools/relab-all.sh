#!/bin/bash

. ./pipeline.source
conda activate humann

for s in `tail -n +2 Samples.txt`
do
    humann_renorm_table -i NON-HOST/HUMANN/$s/${s}_ec.tsv \
			-o NON-HOST/HUMANN/$s/${s}_ec-relab.tsv --units relab --update-snames
    humann_renorm_table -i NON-HOST/HUMANN/$s/${s}_pathabundance.tsv \
			-o NON-HOST/HUMANN/$s/${s}_pathabundance-relab.tsv --units relab --update-snames

    humann_split_stratified_table -i NON-HOST/HUMANN/$s/${s}_ec-relab.tsv -o NON-HOST/HUMANN/$s/
    humann_split_stratified_table -i NON-HOST/HUMANN/$s/${s}_genefamilies-relab.tsv -o NON-HOST/HUMANN/$s/
    humann_split_stratified_table -i NON-HOST/HUMANN/$s/${s}_pathabundance-relab.tsv -o NON-HOST/HUMANN/$s/
done

conda deactivate
