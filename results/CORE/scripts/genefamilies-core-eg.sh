#!/bin/bash

awk -F"\t" '($2>0.0001)' CORE-DIR/Mucosa-AscendingColon/*_genefamilies-relab_unstratified.tsv | cut -f 1 | grep -v '^#' | tr " " "-" | sort | uniq -c | sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > genefamilies-Mucosa-AscendingColon.txt
