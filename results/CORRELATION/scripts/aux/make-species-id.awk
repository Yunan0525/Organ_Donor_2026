BEGIN { FS="\t"; }

(NR==FNR)&&(FNR==1) { print $0; }

(NR==FNR) { id[$1] = $2; }

(NR!=FNR)&&(FNR>1) { print $1"\t"id[$1]"\tS"; }
