BEGIN { FS="\t"; }

(NR==1) { print $0; }

(NR>1) {
    sum = 0;
    prev = 0;

    for (i=2; i<=NF; i++) {
	sum += $i;
	prev += ( ($i>0.0) ? 1 : 0 );
    }
    prev /= (NF-1);

    if ((sum > 5000) && (prev > 0.2)) {
	print $0;
    }
}
