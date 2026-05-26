BEGIN { FS="\t"; }

(NR==FNR) { names[$1]=$2; }

(NR!=FNR) { print $0"\t"names[$1]; }
