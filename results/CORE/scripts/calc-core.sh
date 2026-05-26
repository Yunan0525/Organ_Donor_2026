#!/bin/bash

mkdir -p Bracken-Core-${1}-0.5

awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-AscendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Lumen-AscendingColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-TransverseColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Lumen-TransverseColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-DescendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Lumen-DescendingColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-Duodenum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Lumen-Duodenum.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-Ileum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Lumen-Ileum.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-Jejunum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Lumen-Jejunum.txt

awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-AscendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa-AscendingColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-TransverseColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa-TransverseColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-DescendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa-DescendingColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-Duodenum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa-Duodenum.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-Ileum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa-Ileum.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-Jejunum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=4) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa-Jejunum.txt

awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/*-AscendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=8) {print $2;}' > Bracken-Core-${1}-0.5/AscendingColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/*-TransverseColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=8) {print $2;}' > Bracken-Core-${1}-0.5/TransverseColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/*-DescendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=8) {print $2;}' > Bracken-Core-${1}-0.5/DescendingColon.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/*-Duodenum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=7) {print $2;}' > Bracken-Core-${1}-0.5/Duodenum.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/*-Ileum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=8) {print $2;}' > Bracken-Core-${1}-0.5/Ileum.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/*-Jejunum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=8) {print $2;}' > Bracken-Core-${1}-0.5/Jejunum.txt

awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Mucosa-*/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=23) {print $2;}' > Bracken-Core-${1}-0.5/Mucosa.txt
awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-*/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=24) {print $2;}' > Bracken-Core-${1}-0.5/Lumen.txt

awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-AscendingColon/*.bracken.out CORE-DIR/Mucosa-AscendingColon/*.bracken.out CORE-DIR/Lumen-TransverseColon/*.bracken.out CORE-DIR/Mucosa-TransverseColon/*.bracken.out CORE-DIR/Lumen-DescendingColon/*.bracken.out CORE-DIR/Mucosa-DescendingColon/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=23) {print $2;}' > Bracken-Core-${1}-0.5/LargeIntestine.txt

awk -F"\t" -vTHRESH=$1 '($7>THRESH)' CORE-DIR/Lumen-Duodenum/*.bracken.out CORE-DIR/Mucosa-Duodenum/*.bracken.out CORE-DIR/Lumen-Jejunum/*.bracken.out CORE-DIR/Mucosa-Jejunum/*.bracken.out CORE-DIR/Lumen-Ileum/*.bracken.out CORE-DIR/Mucosa-Ileum/*.bracken.out | cut -f 1 | grep -v name | tr " " "-" | sort | uniq -c| sed 's/^ \+//g' | tr " " "\t" | awk -F"\t" '($1>=23) {print $2;}' > Bracken-Core-${1}-0.5/SmallIntestine.txt

