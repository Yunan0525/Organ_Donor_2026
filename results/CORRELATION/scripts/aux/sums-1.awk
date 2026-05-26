BEGIN { FS="\t"; }

(NR==1) {
    for (i=2; i<=NF; i++) {
	name[i] = $i;
    }
}

(NR>1) {
    for (i=2; i<=NF; i++) {
	sum[i] += $i;
    }
}

END {
    for (i=2; i<=NF; i++) {
	print name[i]"\t"sum[i];
    }
}
