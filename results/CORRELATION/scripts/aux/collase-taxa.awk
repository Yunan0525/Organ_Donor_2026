BEGIN { FS="\t"; }

(NR==FNR) {
    category[$1] = $2;
}

(NR!=FNR)&&(FNR==1) {
    for (i=2; i<=NF; i++) {
	samples[i] = $i;
    }
    print $0;
}

(NR!=FNR)&&(FNR>1) {

    c = category[$1];
    categories[c] = c;

    for (i=2; i<=NF; i++) {
	count[c,i] += $i;
    }
}

END {

    for (c in categories) {

	line = c;
	for (i=2; i<=NF; i++) {
	    line = line"\t"count[c,i];
	}
	print line;

    }
}
