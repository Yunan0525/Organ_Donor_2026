BEGIN { FS="\t"; }

(NR==FNR) { keep[$1] = $1; }

(NR!=FNR)&&($1 in keep)
