#!/bin/bash

set -euo pipefail



OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"

GENOME_DIR="genome"



PATTERN="glycosidase|glycosyl|carbohydrate|sugar|galactose|lactose|cellulose|ABC|transporter|permease|PTS|mucin|adhesin|pilus|fimbr|phage|integrase|transposase|stress|bile|resistance|regulator|transcription|MFS|OsmC|glucan|kinase"



for S in Bl-ODIWGS87 Bl-ODIWGS93

do

  echo "Processing $S..."



  OUTFILE="$OUTDIR/$S.unique_keyword_annotations.gff"



  awk -v pattern="$PATTERN" '

    BEGIN { IGNORECASE=1 }



    NR==FNR {

      ids[$1]=1

      next

    }



    $0 ~ /^#/ { next }



    {

      for (id in ids) {

        if ($0 ~ ("ID=" id) || $0 ~ ("," id) || $0 ~ (";" id) || $0 ~ id) {

          if ($0 ~ pattern) {

            print $0

          }

          break

        }

      }

    }

  ' "$OUTDIR/$S.unique_genes.txt" "$GENOME_DIR/$S.gff" > "$OUTFILE"



  echo "$S keyword hits saved to:"

  echo "$OUTFILE"

  echo "Number of hits:"

  wc -l "$OUTFILE"

  echo ""

done
