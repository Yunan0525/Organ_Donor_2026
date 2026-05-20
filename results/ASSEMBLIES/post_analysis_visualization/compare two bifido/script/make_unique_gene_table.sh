#!/bin/bash

set -euo pipefail



OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"

GENOME_DIR="genome"



for S in Bl-ODIWGS87 Bl-ODIWGS93

do

  echo "Processing $S..."



  IDFILE="$OUTDIR/$S.unique_genes.txt"

  GFF="$GENOME_DIR/$S.gff"

  OUTFILE="$OUTDIR/$S.unique_gene_table.tsv"



  echo -e "Gene_ID\tContig\tStart\tEnd\tStrand\tProduct" > "$OUTFILE"



  awk -F'\t' '

    BEGIN { OFS="\t" }



    NR==FNR {

      ids[$1]=1

      next

    }



    $0 ~ /^#/ { next }



    {

      attr = $9

      id = ""

      product = "NA"



      # extract ID

      if (match(attr, /ID=[^;]+/)) {

        id = substr(attr, RSTART, RLENGTH)

        sub(/^ID=/, "", id)

      }



      # extract product

      if (match(attr, /product=[^;]+/)) {

        product = substr(attr, RSTART, RLENGTH)

        sub(/^product=/, "", product)

      }



      if (id in ids) {

        print id, $1, $4, $5, $7, product

      }

    }



  ' "$IDFILE" "$GFF" >> "$OUTFILE"



  echo "Saved:"

  echo "$OUTFILE"

  echo "Rows:"

  wc -l "$OUTFILE"

  echo ""

done



echo "Done."
