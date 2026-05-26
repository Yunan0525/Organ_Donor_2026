BEGIN { FS="\t"; }

(NR==FNR) { category[$1]=$3; }

(NR!=FNR)&&(FNR==1) { print $0; }

(NR!=FNR)&&(FNR>1) {
    cat = category[$1];

    for (i=2; i<=NF; i++) {
	if (cat=="Archaea") {
	    archaea[i] += $i;
	}
	if (cat=="Bacteria") {
	    bacteria[i] += $i;
	}
	if (cat=="Fungi") {
	    fungi[i] += $i;
	}
	if (cat=="Other") {
	    other[i] += $i;
	}
	if (cat=="Virus") {
	    virus[i] += $i;
	}
    }
}

END {
    line="Archaea";
    for (i=2; i<=NF; i++) {
	line = line"\t"archaea[i];
    }
    print line;
    
    line="Bacteria";
    for (i=2; i<=NF; i++) {
	line = line"\t"bacteria[i];
    }
    print line;
    
    line="Fungi";
    for (i=2; i<=NF; i++) {
	line = line"\t"fungi[i];
    }
    print line;
    
    line="Other";
    for (i=2; i<=NF; i++) {
	line = line"\t"other[i];
    }
    print line;
    
    line="Virus";
    for (i=2; i<=NF; i++) {
	line = line"\t"virus[i];
    }
    print line;
    
}
