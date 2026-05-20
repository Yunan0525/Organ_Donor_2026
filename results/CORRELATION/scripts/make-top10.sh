#!/bin/bash

awk -f scripts/aux/species-abundance.awk $1.biom.txt | sort -t$'\t' -grk 2 | \
    awk -f scripts/aux/select-top10.awk $1.species.pheatmap.clusters.txt - > $1.top10.txt

