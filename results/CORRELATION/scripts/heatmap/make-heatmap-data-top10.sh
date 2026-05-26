#!/bin/bash

awk -f scripts/aux/linearize-ccrepe.awk ../BIPLOTs/$1.top10.txt ../$1.bracken-5000-20.species.score.txt > $1.heatmap.txt
