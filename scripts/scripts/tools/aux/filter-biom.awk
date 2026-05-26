BEGIN { FS="\t"; }

(NR==1) { print $0; }

(NR>1) {

    sum = 0.0;
    n = 0;

    for (i=2; i<=NF; i++) {
	sum += $i;
	n += ($i > 0) ? 1 : 0;
    }

    prev = n / (NF-1);

    if ( (sum > 500) && (prev > 0.05)) {
	print $0;
    }
    
}
