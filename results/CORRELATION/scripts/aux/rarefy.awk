BEGIN { FS="\t"; }

(FNR==1)&&(FNR==NR) {
    for (i=2; i<=NF; i++) {
	name[i] = $i;
    }
}

(FNR>1)&&(FNR==NR) {
    for (i=2; i<=NF; i++) {
	sum[i] += $i;
    }
}

(FNR==1)&&(FNR!=NR) {
    line = $1;
    for (i=2; i<=NF; i++) {
	if (sum[i] > 1000000) {
	    line = line"\t"name[i];
	}
    }
    print line;
}

(FNR>1)&&(FNR!=NR) {
    line = $1;
    for (i=2; i<=NF; i++) {
	if (sum[i] > 1000000) {
	    value = int(1000000*$i/sum[i]);
	    line = line"\t"value;
	}
    }
    print line;
}
