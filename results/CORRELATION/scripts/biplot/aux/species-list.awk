BEGIN { FS="\t"; }

(NR==FNR) { cluster[$1] = $11; }

(NR!=FNR) {
    sum = 0.0;
    for (i=2; i<=NF; i++) {
	sum += $i;
    }
    print $1"\t"cluster[$1]"\t"sum;
}
