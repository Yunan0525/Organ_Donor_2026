#!/bin/bash

set -euo pipefail



OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"

GENOME_DIR="genome"



for S in Bl-ODIWGS87 Bl-ODIWGS93

do

  echo "Processing $S..."



  IDFILE="$OUTDIR/$S.unique_genes.txt"

  GFF="$GENOME_DIR/$S.gff"

  OUTFILE="$OUTDIR/$S.unique_gene_coordinates.tsv"



  awk '

    BEGIN { OFS="\t" }



    NR==FNR {

      ids[$1] = 1

      next

    }



    $0 ~ /^#/ { next }



    {

      attr = $9

      id = ""



      if (match(attr, /(^|;)ID=[^;]+/)) {

        id = substr(attr, RSTART, RLENGTH)

        sub(/^.*ID=/, "", id)

      }



      if (id in ids) {

        print $1, $4, $5, $7, id

      }

    }

  ' "$IDFILE" "$GFF" > "$OUTFILE"



  echo "Saved:"

  echo "$OUTFILE"

  echo "Rows:"

  wc -l "$OUTFILE"

  echo ""

done



echo "Done."
