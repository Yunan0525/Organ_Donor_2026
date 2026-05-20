#!/bin/bash

set -euo pipefail



SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROJECT_DIR="$(dirname "$SCRIPT_DIR")"



GENOME_DIR="$PROJECT_DIR/genome"

OUTDIR="$PROJECT_DIR/Bl_ODIWGS87_vs_ODIWGS93_results/blast_orthologs"



S1="Bl-ODIWGS87"

S2="Bl-ODIWGS93"



mkdir -p "$OUTDIR"



echo "Checking required tools..."

for tool in gffread makeblastdb blastp awk sort cut grep comm sed; do

  if ! command -v "$tool" > /dev/null 2>&1; then

    echo "ERROR: $tool not found"

    exit 1

  fi

done



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



echo "Extracting proteins..."

gffread "$GENOME_DIR/$S1.gff" -g "$GENOME_DIR/$S1.fna" -y "$OUTDIR/$S1.faa"

gffread "$GENOME_DIR/$S2.gff" -g "$GENOME_DIR/$S2.fna" -y "$OUTDIR/$S2.faa"



echo "Protein counts:"

echo "$S1: $(grep -c '^>' "$OUTDIR/$S1.faa")"

echo "$S2: $(grep -c '^>' "$OUTDIR/$S2.faa")"



echo "Building BLAST databases..."

makeblastdb -in "$OUTDIR/$S1.faa" -dbtype prot -out "$OUTDIR/$S1.db"

makeblastdb -in "$OUTDIR/$S2.faa" -dbtype prot -out "$OUTDIR/$S2.db"



echo "Running BLASTP $S1 vs $S2..."

blastp -query "$OUTDIR/$S1.faa" -db "$OUTDIR/$S2.db" -out "$OUTDIR/${S1}_vs_${S2}.blast.tsv" -outfmt "6 qseqid sseqid pident length qlen slen evalue bitscore" -evalue 1e-5 -max_target_seqs 10 -num_threads 4



echo "Running BLASTP $S2 vs $S1..."

blastp -query "$OUTDIR/$S2.faa" -db "$OUTDIR/$S1.db" -out "$OUTDIR/${S2}_vs_${S1}.blast.tsv" -outfmt "6 qseqid sseqid pident length qlen slen evalue bitscore" -evalue 1e-5 -max_target_seqs 10 -num_threads 4



echo "Getting best hits..."

sort -k1,1 -k8,8nr "$OUTDIR/${S1}_vs_${S2}.blast.tsv" | awk '!seen[$1]++' > "$OUTDIR/${S1}_vs_${S2}.besthit.tsv"

sort -k1,1 -k8,8nr "$OUTDIR/${S2}_vs_${S1}.blast.tsv" | awk '!seen[$1]++' > "$OUTDIR/${S2}_vs_${S1}.besthit.tsv"



echo "Filtering high-confidence homologs..."

awk 'BEGIN{OFS="\t"} {qcov=$4/$5; scov=$4/$6; if ($3 >= 80 && qcov >= 0.70 && scov >= 0.70) print $1,$2,$3,$4,$5,$6,qcov,scov,$7,$8}' "$OUTDIR/${S1}_vs_${S2}.besthit.tsv" > "$OUTDIR/${S1}_vs_${S2}.highconf.tsv"



awk 'BEGIN{OFS="\t"} {qcov=$4/$5; scov=$4/$6; if ($3 >= 80 && qcov >= 0.70 && scov >= 0.70) print $1,$2,$3,$4,$5,$6,qcov,scov,$7,$8}' "$OUTDIR/${S2}_vs_${S1}.besthit.tsv" > "$OUTDIR/${S2}_vs_${S1}.highconf.tsv"



echo "Finding reciprocal best hits..."

awk 'BEGIN{OFS="\t"} {print $1,$2}' "$OUTDIR/${S1}_vs_${S2}.highconf.tsv" | sort > "$OUTDIR/tmp1.tsv"

awk 'BEGIN{OFS="\t"} {print $2,$1}' "$OUTDIR/${S2}_vs_${S1}.highconf.tsv" | sort > "$OUTDIR/tmp2.tsv"



comm -12 "$OUTDIR/tmp1.tsv" "$OUTDIR/tmp2.tsv" > "$OUTDIR/reciprocal_best_hits.tsv"



rm "$OUTDIR/tmp1.tsv" "$OUTDIR/tmp2.tsv"



echo "Extracting unique genes..."

grep '^>' "$OUTDIR/$S1.faa" | sed 's/^>//' | awk '{print $1}' | sort > "$OUTDIR/${S1}.all_genes.txt"

grep '^>' "$OUTDIR/$S2.faa" | sed 's/^>//' | awk '{print $1}' | sort > "$OUTDIR/${S2}.all_genes.txt"



cut -f1 "$OUTDIR/reciprocal_best_hits.tsv" | sort > "$OUTDIR/${S1}.shared_genes.txt"

cut -f2 "$OUTDIR/reciprocal_best_hits.tsv" | sort > "$OUTDIR/${S2}.shared_genes.txt"



comm -23 "$OUTDIR/${S1}.all_genes.txt" "$OUTDIR/${S1}.shared_genes.txt" > "$OUTDIR/${S1}.unique_genes.txt"

comm -23 "$OUTDIR/${S2}.all_genes.txt" "$OUTDIR/${S2}.shared_genes.txt" > "$OUTDIR/${S2}.unique_genes.txt"



echo "Writing summary..."

{

  echo "Comparison: $S1 vs $S2"

  echo "$S1 total proteins: $(wc -l < "$OUTDIR/${S1}.all_genes.txt")"

  echo "$S2 total proteins: $(wc -l < "$OUTDIR/${S2}.all_genes.txt")"

  echo "$S1 shared genes: $(wc -l < "$OUTDIR/${S1}.shared_genes.txt")"

  echo "$S2 shared genes: $(wc -l < "$OUTDIR/${S2}.shared_genes.txt")"

  echo "$S1 unique genes: $(wc -l < "$OUTDIR/${S1}.unique_genes.txt")"

  echo "$S2 unique genes: $(wc -l < "$OUTDIR/${S2}.unique_genes.txt")"

} > "$OUTDIR/summary.txt"



cat "$OUTDIR/summary.txt"



echo "Done."
