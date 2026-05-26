#!/bin/bash

for s in `tail -n +2 Samples.txt`
do
#    python3 /nas/longleaf/apps/kraken2/2.1.2/src/Bracken-2.6.2/src/est_abundance.py \
#	    -i KREPORTs/$s.kreport -l K \
#	    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
#	    -o BRACKEN/${s}-K.bracken.out
#    python3 /nas/longleaf/apps/kraken2/2.1.2/src/Bracken-2.6.2/src/est_abundance.py \
#	    -i KREPORTs/$s.kreport -l P \
#	    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
#	    -o BRACKEN/${s}-P.bracken.out
    python3 /nas/longleaf/apps/kraken2/2.1.2/src/Bracken-2.6.2/src/est_abundance.py \
	    -i KREPORTs/$s.kreport -l C \
	    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
	    -o BRACKEN/${s}-C.bracken.out
#    python3 /nas/longleaf/apps/kraken2/2.1.2/src/Bracken-2.6.2/src/est_abundance.py \
#	    -i KREPORTs/$s.kreport -l O \
#	    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
#	    -o BRACKEN/${s}-O.bracken.out
#    python3 /nas/longleaf/apps/kraken2/2.1.2/src/Bracken-2.6.2/src/est_abundance.py \
#	    -i KREPORTs/$s.kreport -l F \
#	    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
#	    -o BRACKEN/${s}-F.bracken.out
#    python3 /nas/longleaf/apps/kraken2/2.1.2/src/Bracken-2.6.2/src/est_abundance.py \
#	    -i KREPORTs/$s.kreport -l G \
#	    -k /proj/pyro_lab/JMR/WGS/KRAKEN2-HS/KRAKEN2-HS-FUNGI-DB/database150mers.kmer_distrib \
#	    -o BRACKEN/${s}-G.bracken.out
done
