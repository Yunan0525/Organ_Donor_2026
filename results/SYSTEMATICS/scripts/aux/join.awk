BEGIN { FS="\t"; }

(NR==FNR) { name[$1]=$2; }

(NR!=FNR)&&(FNR==1) { print $0; }

(NR!=FNR)&&(FNR>1) {
    if ($1 in name) {
	line = name[$1];

	for (i=2; i<=NF; i++) {
	    line = line"\t"$i;
	}

	print line;
    }
}

