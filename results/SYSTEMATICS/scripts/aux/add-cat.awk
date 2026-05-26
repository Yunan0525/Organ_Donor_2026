BEGIN { FS="\t"; }

(NR==FNR) { cat[$2] = $1; }

(NR!=FNR) { print $0"\t"cat[$2]; }

