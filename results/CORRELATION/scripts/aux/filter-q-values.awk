BEGIN { FS="\t"; }

(NR==FNR)&&(NR>1) {
    n = 0;
    for (i=2; i<=NF; i++) {
	if ($i < 0.05) {
	    n += 1;
	}
    }
    
    if (n >= 5) {
	keep[$1] = $1;
    }
}

(NR!=FNR)&&(FNR==1) {
    line = "SPECIES";
    for (i=1; i<=NF; i++) {
	if ($i in keep) {
	    keep_idx[i+1] = i+1;
	    line = line"\t"$i;
	}
    }
    gsub("^SPECIES\t","",line);
    print line;
}

(NR!=FNR)&&(FNR>1)&&($1 in keep) {
    line = $1;
    for (i=2; i<=NF; i++) {
	if (i in keep_idx) {
	    line = line"\t"$i;
	}
    }
    print line;
}
