#!/bin/bash



set -euo pipefail



BASE_DIR="/work/users/y/u/yunan/organ_donor/assemble/between_section/May01"

ASSEMBLY_DIR="$BASE_DIR/genome/ASSEMBLIES"

FAA_DIR="$BASE_DIR/faa"



mkdir -p "$FAA_DIR"



echo "Start extracting proteins..."



for fna in "$ASSEMBLY_DIR"/*.fna; do

    base=$(basename "$fna" .fna)

    gff="$ASSEMBLY_DIR/${base}.gff"



    if [ -f "$gff" ]; then

        echo "Processing $base"

        gffread "$gff" -g "$fna" -y "$FAA_DIR/${base}.faa"

    else

        echo "WARNING: Missing GFF for $base"

    fi

done



echo "Done extracting proteins."
