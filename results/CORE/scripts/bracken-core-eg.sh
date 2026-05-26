#!/bin/bash

awk -F"\t" '($7>0.0001)' Lumen-TransverseColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Lumen-TransverseColon.txt
