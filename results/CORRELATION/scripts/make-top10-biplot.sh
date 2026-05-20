#!/bin/bash

sh scripts/make-biplot.sh $1.bracken-5000-35
sh scripts/make-pheatmap.sh $1.bracken-5000-35.species
sh scripts/make-top10.sh $1.bracken-5000-35

awk -f scripts/aux/score-top10-only.awk $1.bracken-5000-35.top10.txt $1.bracken-5000-35.species.score.txt \
    > $1.top10.score.txt
sh scripts/make-pheatmap.sh $1.top10
