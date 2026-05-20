#!/bin/bash

for s in `tail -n +2 Samples.txt`
do
    rm NON-HOST/META-ASM/$s/*.gfa
    rm NON-HOST/META-ASM/$s/*.fastg
    rm NON-HOST/META-ASM/$s/*.fasta
    rm NON-HOST/META-ASM/$s/*.paths
    rm NON-HOST/META-ASM/$s/*.info
    rm NON-HOST/META-ASM/$s/*.yaml
    rm NON-HOST/META-ASM/$s/*.sh
    rm NON-HOST/META-ASM/$s/*.txt

    rm -rf NON-HOST/META-ASM/$s/corrected
    rm -rf NON-HOST/META-ASM/$s/K??
    rm -rf NON-HOST/META-ASM/$s/misc
    rm -rf NON-HOST/META-ASM/$s/pipeline_state
    rm -rf NON-HOST/META-ASM/$s/tmp

    cp NON-HOST/META-ASM/$s/RESMICO/$s.blast-hits.txt NON-HOST/META-ASM/$s/$s.ANNOTATION
    rm -rf NON-HOST/META-ASM/$s/PRE-ANNOTATION
    rm -rf NON-HOST/META-ASM/$s/RESMICO

    rm EXTRACTs/UNK/META-ASM/$s/*.gfa
    rm EXTRACTs/UNK/META-ASM/$s/*.fastg
    rm EXTRACTs/UNK/META-ASM/$s/*.fasta
    rm EXTRACTs/UNK/META-ASM/$s/*.paths
    rm EXTRACTs/UNK/META-ASM/$s/*.info
    rm EXTRACTs/UNK/META-ASM/$s/*.yaml
    rm EXTRACTs/UNK/META-ASM/$s/*.sh
    rm EXTRACTs/UNK/META-ASM/$s/*.txt

    rm -rf EXTRACTs/UNK/META-ASM/$s/corrected
    rm -rf EXTRACTs/UNK/META-ASM/$s/K??
    rm -rf EXTRACTs/UNK/META-ASM/$s/misc
    rm -rf EXTRACTs/UNK/META-ASM/$s/pipeline_state
    rm -rf EXTRACTs/UNK/META-ASM/$s/tmp

    cp EXTRACTs/UNK/META-ASM/$s/RESMICO/$s.blast-hits.txt EXTRACTs/UNK/META-ASM/$s/$s.ANNOTATION
    rm -rf EXTRACTs/UNK/META-ASM/$s/PRE-ANNOTATION
    rm -rf EXTRACTs/UNK/META-ASM/$s/RESMICO

done
