#!/bin/bash

. ../pipeline.source

conda activate blast
blastn -db VecScreen/UniVecDB -query $1.fna -num_threads 1 -task blastn -reward 1 -penalty -5 -gapopen 3 -gapextend 3\
       -dust yes -soft_masking true -evalue .01 -searchsp 1750000000000 -outfmt 6 > $1.vec-screen.txt &
conda deactivate
