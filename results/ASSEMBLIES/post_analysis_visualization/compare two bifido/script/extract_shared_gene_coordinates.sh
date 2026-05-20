#!/bin/bash

set -euo pipefail



OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"

GENOME_DIR="genome"



# shared IDs from reciprocal best hits

cut -f1 "$OUTDIR/reciprocal_best_hits.tsv" | sort > "$OUTDIR/Bl-ODIWGS87.shared_genes.txt"

cut -f2 "$OUTDIR/reciprocal_best_hits.tsv" | sort > "$OUTDIR/Bl-ODIWGS93.shared_genes.txt"



for S in Bl-ODIWGS87 Bl-ODIWGS93

do

  echo "Processing $S shared genes..."



  IDFILE="$OUTDIR/$S.shared_genes.txt"

  GFF="$GENOME_DIR/$S.gff"

  OUTFILE="$OUTDIR/$S.shared_gene_coordinates.tsv"



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



  wc -l "$OUTFILE"

done
