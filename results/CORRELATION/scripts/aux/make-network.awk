BEGIN { FS="\t"; }

(NR>1) {
    for (i=2; i<=NF; i++) {
	if ($i<1.0) {
	    if ((i-2) < (NR-2)) {
		print (i-2)"\t"(NR-2)"\t"(1.0-$i);
	    }
	}
    }
}
