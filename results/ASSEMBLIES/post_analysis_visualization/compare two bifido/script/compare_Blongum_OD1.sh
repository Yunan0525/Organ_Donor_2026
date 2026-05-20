#!/bin/bash

set -euo pipefail

module load mummer/4.0.1


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROJECT_DIR="$(dirname "$SCRIPT_DIR")"



GENOME_DIR="$PROJECT_DIR/genome"

OUTDIR="$PROJECT_DIR/Bl_ODIWGS87_vs_ODIWGS93_results"



S1="Bl-ODIWGS87"

S2="Bl-ODIWGS93"



mkdir -p "$OUTDIR"



echo "Running from: $PWD"

echo "Genome dir: $GENOME_DIR"



# -------------------------

# Check files

# -------------------------

echo "Checking input files..."



FILES=(

  "$GENOME_DIR/$S1.fna"

  "$GENOME_DIR/$S1.gff"

  "$GENOME_DIR/$S2.fna"

  "$GENOME_DIR/$S2.gff"

)



for f in "${FILES[@]}"; do

  if [[ ! -f "$f" ]]; then

    echo "Missing file: $f"

    exit 1

  fi

done



echo "Input files found."



# -------------------------

# 1. ANI

# -------------------------

echo "Running fastANI..."

fastANI -q "$GENOME_DIR/$S1.fna" -r "$GENOME_DIR/$S2.fna" -o "$OUTDIR/ANI.txt"



# -------------------------

# 2. nucmer alignment

# -------------------------

echo "Running nucmer..."

nucmer --prefix="$OUTDIR/compare" "$GENOME_DIR/$S1.fna" "$GENOME_DIR/$S2.fna"



echo "Filtering delta..."

delta-filter -1 "$OUTDIR/compare.delta" > "$OUTDIR/compare.filtered.delta"



echo "Generating coordinates..."

show-coords -rcl "$OUTDIR/compare.filtered.delta" > "$OUTDIR/compare.coords.txt"



# -------------------------

# 3. SNPs

# -------------------------

echo "Extracting SNPs..."

show-snps -Clr "$OUTDIR/compare.filtered.delta" > "$OUTDIR/compare.snps.txt"




echo "Done!"

echo ""

echo "Key outputs:"

echo "ANI: $OUTDIR/ANI.txt"

echo "SNPs: $OUTDIR/compare.snps.txt"
