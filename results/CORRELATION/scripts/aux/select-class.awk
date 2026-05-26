BEGIN { FS="\t"; }

(NR==FNR)&&(FNR>1) {
    if ($5=="Small_intestine") {
	keep[$1] = $1;
    }
}

(NR!=FNR)&&(FNR==1) {
    line = $1;
    for (i=2; i<=NF; i++) {
	if ($i in keep) {
	    keepid[i] = i;
	    line = line"\t"$i;
	}
    }
    print line;
}

(NR!=FNR)&&(FNR>1) {
    line = $1;
    for (i=2; i<=NF; i++) {
	if (i in keepid) {
	    line = line"\t"$i;
	}
    }
    print line;
}
