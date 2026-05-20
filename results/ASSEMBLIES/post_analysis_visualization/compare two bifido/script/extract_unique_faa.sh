#!/bin/bash

set -euo pipefail



OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"



extract_fasta_by_id () {

  local idfile="$1"

  local fastafile="$2"

  local outfile="$3"



  awk '

    NR==FNR {

      ids[$1]=1

      next

    }

    /^>/ {

      header=$0

      id=$1

      sub(/^>/, "", id)

      keep=(id in ids)

    }

    keep {

      print

    }

  ' "$idfile" "$fastafile" > "$outfile"

}



extract_fasta_by_id "$OUTDIR/Bl-ODIWGS87.unique_genes.txt" "$OUTDIR/Bl-ODIWGS87.faa" "$OUTDIR/Bl-ODIWGS87.unique.faa"

extract_fasta_by_id "$OUTDIR/Bl-ODIWGS93.unique_genes.txt" "$OUTDIR/Bl-ODIWGS93.faa" "$OUTDIR/Bl-ODIWGS93.unique.faa"



echo "Bl-ODIWGS87 unique proteins:"

grep -c "^>" "$OUTDIR/Bl-ODIWGS87.unique.faa"



echo "Bl-ODIWGS93 unique proteins:"

grep -c "^>" "$OUTDIR/Bl-ODIWGS93.unique.faa"



echo "Done."
