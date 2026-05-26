BEGIN { FS="\t"; }

(FNR==1)&&(FNR==NR) {
    for (i=4; i<=NF; i+=2) {
	split($i,sa,".");
	name[i] = sa[1];
    }
}

(FNR>1)&&(FNR==NR) {
    for (i=4; i<=NF; i+=2) {
	sum_count[i] += $i;
	sum_perct[i] += $(i+1);
    }
}

(FNR==1)&&(FNR==NR) {
    for (i=4; i<=NF; i+=2) {
	split($i,sa,".");
	name[i] = sa[1];
    }
}

(FNR>1)&&(FNR==NR) {
    for (i=4; i<=NF; i+=2) {
	sum[i] += $i;
    }
}

(FNR==1)&&(FNR!=NR) {
    line = $1;
    for (i=4; i<=NF; i+=2) {
	if (sum[i] > 1000000) {
	    line = line"\t"name[i];
	}
    }
    print line;
}

(FNR>1)&&(FNR!=NR) {
    line = $1;
    for (i=4; i<=NF; i+=2) {
	if (sum[i] > 1000000) {
	    value = int(1000000*$i/sum[i]);
	    line = line"\t"value;
	}
    }
    print line;
}
