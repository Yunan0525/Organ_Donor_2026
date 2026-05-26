BEGIN { FS="\t"; }

(NR==FNR) { len[$1]=$2; }

(NR!=FNR) { print $1"\t"$2"\t"len[$2]; }
