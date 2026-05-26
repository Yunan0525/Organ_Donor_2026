BEGIN { FS="\t"; }

(NR==FNR) { name[$1] = $2; }

(NR!=FNR) { print name[$1]"\t"$2; }

