#!/bin/bash

grep '^>' NON-HOST/META-ASM/*/*.ANNOTATION/genome.fna | tr ":" "\t" |
    awk -f scripts/tools/aux/mis-assem.awk -vLEN_THRESH=$1 -vSAMPLE_POS=3 REFs/id-names.txt -


