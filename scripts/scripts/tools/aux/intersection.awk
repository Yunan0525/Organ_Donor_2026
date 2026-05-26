BEGIN { FS="\t"; }

(NR==FNR) { keep[$1,$2,$3,$4]=$1"\t"$2"\t"$3"\t"$4; }

(NR!=FNR) {
    if (keep[$1,$2,$3,$4]) {
	print $0;
    }
}
