#!/bin/bash

. ../pipeline.source

conda activate kraken

for s in `tail -n +2 ../Samples.txt`
do
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l K \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-K.bracken.out
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l P \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-P.bracken.out
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l C \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-C.bracken.out
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l O \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-O.bracken.out
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l F \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-F.bracken.out
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l G \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-G.bracken.out
    est_abundance.py \
	    -i ../KREPORTs/$s.kreport -l S \
	    -k /nas/longleaf/home/roachjm/work/projects/KRAKEN2-GUT/KRAKEN2-GUT-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-S.bracken.out
done

conda deactivate
