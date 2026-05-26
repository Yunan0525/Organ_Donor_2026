BEGIN { FS="\t"; }

{
    if (NR==1) {
	print $1"\t"$2"\t"$3;
    } else {
	sum = 0;
	for (i=4; i<=NF; i+=2) {
	    sum += $i;
	}

	if (sum > 100000) {
	    print $1"\t"$2"\t"$3;
	}
    }
}
