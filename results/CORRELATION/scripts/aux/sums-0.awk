BEGIN { FS="\t"; }

(NR==1) {
    for (i=4; i<=NF; i+=2) {
	split($i,sa,".");
	name[i] = sa[1];
    }
}

(NR>1) {
    for (i=4; i<=NF; i+=2) {
	sum_count[i] += $i;
	sum_perct[i] += $(i+1);
    }
}

END {
    for (i=4; i<=NF; i+=2) {
	print name[i]"\t"sum_count[i]"\t"sum_perct[i];
    }
}
