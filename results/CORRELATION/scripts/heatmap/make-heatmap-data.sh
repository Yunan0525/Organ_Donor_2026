#!/bin/bash

awk -f scripts/aux/linearize-ccrepe.awk ../Species-100k-100k.txt ../$1.species.score.txt > $1.heatmap.txt
