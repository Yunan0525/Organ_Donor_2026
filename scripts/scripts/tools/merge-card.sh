#!/bin/bash

awk -f scripts/tools/aux/merge-card.awk Samples.txt NON-HOST/CARD/*.vsearch.quant.txt
