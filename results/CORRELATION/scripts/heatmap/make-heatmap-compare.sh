#!/bin/bash

awk -f scripts/aux/linearize-compare.awk $1.heatmap.txt $2.heatmap.txt > ${1}v${2}.heatmap.txt
