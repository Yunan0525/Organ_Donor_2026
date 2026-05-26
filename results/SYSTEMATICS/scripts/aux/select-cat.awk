BEGIN { FS="\t"; }

(NR==FNR)&&($3==CAT) { keep[$1] = $1; }

(NR!=FNR)&&(($1 in keep)||(FNR==1))
