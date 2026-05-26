BEGIN { FS="\t"; }

(NR==FNR)&&(NR>1) { value[$1,$2] = $3; } 

(NR!=FNR)&&(FNR==1) { print "Species1\tSpecies2\tValues"; }

(NR!=FNR)&&(FNR>1)  { print $1"\t"$2"\t"(value[$1,$2] - $3);
}
    
