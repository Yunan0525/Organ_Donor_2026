BEGIN { FS="\t"; }

(NR>1) {
    sum = 0.0;
    for (i=2; i<=NF; i++) {
	sum += $i;
    }
    print $1"\t"sum;
}
