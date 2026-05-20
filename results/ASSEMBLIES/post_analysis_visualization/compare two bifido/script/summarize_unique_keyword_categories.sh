#!/bin/bash

set -euo pipefail



OUTDIR="Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"

SUMMARY="$OUTDIR/unique_keyword_category_summary.tsv"



echo -e "Strain\tCategory\tCount" > "$SUMMARY"



for S in Bl-ODIWGS87 Bl-ODIWGS93

do

  FILE="$OUTDIR/$S.unique_keyword_annotations.gff"



  declare -A patterns

  patterns["Carbohydrate_metabolism"]="glycosidase|glycosyl|carbohydrate|sugar|galactose|lactose|cellulose|glucan|kinase"

  patterns["Transporters"]="ABC|transporter|permease|PTS|MFS|efflux"

  patterns["Regulation"]="regulator|transcription|response regulator|TetR|MarR|ROK"

  patterns["Mobile_elements"]="phage|integrase|transposase|IS[0-9]|prophage"

  patterns["Stress_resistance"]="stress|bile|resistance|OsmC|oxidative|detoxification"

  patterns["Adhesion_host_interaction"]="mucin|adhesin|pilus|fimbr"



  for cat in "${!patterns[@]}"

  do

    count=$(grep -iE "${patterns[$cat]}" "$FILE" | wc -l)

    echo -e "$S\t$cat\t$count" >> "$SUMMARY"

  done

done



cat "$SUMMARY"
