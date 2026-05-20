#!/bin/bash

set -euo pipefail



GENOME_DIR="genome"

OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"



for S in Bl-ODIWGS87 Bl-ODIWGS93

do

  awk '

    /^>/ {

      if (seqname != "") print seqname, length(seq)

      seqname=$1

      sub(/^>/,"",seqname)

      seq=""

      next

    }

    {

      seq=seq $0

    }

    END {

      if (seqname != "") print seqname, length(seq)

    }

  ' "$GENOME_DIR/$S.fna" > "$OUTDIR/$S.contig_lengths.tsv"

done
