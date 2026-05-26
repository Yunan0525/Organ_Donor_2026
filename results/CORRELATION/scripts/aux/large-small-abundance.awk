BEGIN { FS="\t"; }

(NR==FNR) { section[$1] = $12; }

(NR!=FNR)&&(FNR==1) {
    for (i=2; i<=NF; i++) {

	if (section[$i] == "Small_intestine") {
	    small[i] = i;
	}

	if (section[$i] == "Large_intestine") {
	    large[i] = i;
	}
    }
}

(NR!=FNR)&&(FNR>1) {

    small_sum = 0;
    for (i in small) {
	small_sum += $i;
    }

    large_sum = 0;
    for (i in large) {
	large_sum += $i;
    }

    print $1"\t"small_sum"\t"large_sum;
}
    
