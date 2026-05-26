BEGIN { FS = "\t"; }

(NR==FNR)&&(FNR==1) {
    for (i=1; i<=NF; i++) {
	name[i+1] = $i;
    }
}

(NR==FNR)&&(FNR>1) {
    for (i=2; i<=NF; i++) {
	if (($i < 1.0e-3) && ($1 > name[i])) {
	    keep[$1,name[i]] = $i;
	}
    }
}

(NR!=FNR)&&(FNR>1) {
    for (i=2; i<=NF; i++) {
	if ((keep[$1,name[i]]) && ($i < 0.0)) {
	    print $i"\t"keep[$1,name[i]]"\t"$1"\t"name[i];
	}
    }
}

