BEGIN { FS="\t"; }

(NR==FNR) { group[$1] = $11; }

(NR!=FNR) { print $0"\t"group[$1]; }
