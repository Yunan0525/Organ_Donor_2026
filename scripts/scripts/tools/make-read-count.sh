#!/bin/bash

grep 'Total reads processed' TRIMMED/*_R1_001.fastq.gz_trimming_report.txt | sed 's/_R1_001.fastq.gz_trimming_report.txt:Total reads processed: \+/\t/g' | tr -d "," | sed 's/^TRIMMED\///g' > Raw.txt
grep 'Total reads processed' NON-HOST/TRIMMED/*.fastq_trimming_report.txt | sed 's/.fastq_trimming_report.txt:Total reads processed: \+/\t/g' | tr -d "," | sed 's/^NON-HOST\/TRIMMED\///g' > Trimmed.txt

paste Raw.txt Trimmed.txt  | awk '($1!=$3)'
paste Raw.txt Trimmed.txt | cut -f 1,2,4 > read-count.txt
rm Raw.txt Trimmed.txt
