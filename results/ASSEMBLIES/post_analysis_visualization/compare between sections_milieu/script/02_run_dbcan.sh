#!/bin/bash



set -euo pipefail



BASE_DIR="/work/users/y/u/yunan/organ_donor/assemble/between_section/May01"

FAA_DIR="$BASE_DIR/faa"

OUT_DIR="$BASE_DIR/dbcan_out"

DB_DIR="$BASE_DIR/dbcan_db"

mkdir -p "$OUT_DIR"



echo "Start running dbCAN..."



for faa in "$FAA_DIR"/*.faa; do

    base=$(basename "$faa" .faa)

    echo "Running dbCAN for $base"



    run_dbcan CAZyme_annotation  --input_raw_data "$faa"  --mode protein   --output_dir "$OUT_DIR/${base}_dbcan"   --db_dir "$DB_DIR"  --methods  hmm  --threads 8
done



echo "Done running dbCAN."
