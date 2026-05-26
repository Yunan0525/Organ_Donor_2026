BEGIN { FS="\t"; }

(NR==FNR)&&(FNR==1) {
    for (i=1; i<=NF; i++) {
	name[i+1] = $i;
    }
}

(NR==FNR)&&(FNR>1) {
    for (i=2; i<=NF; i++) {
	if (i > FNR) {
	    score[$1"-"name[i]]=$i;
	}
    }
}

(NR!=FNR)&&(FNR==1) {
    for (i=1; i<=NF; i++) {
	name[i+1] = $i;
    }
}

(NR!=FNR)&&(FNR>1) {
    for (i=2; i<=NF; i++) {
	if (i > FNR) {
	    print $1"\t"name[i]"\t"score[$1"-"name[i]]"\t"$i;
	}
    }
}
