BEGIN { FS="\t"; }

(NR==FNR)&&(FNR>1) {
    numsamp += 1;
    samples[numsamp] = $1;
}

(NR!=FNR)&&(FNR==1) {
    len = split(FILENAME,sa,"/");
    current = sa[len];
    gsub(".vsearch.quant.txt","",current);
}

(NR!=FNR)&&(FNR>1) {
    split($1,sa,"|");
    cardid = sa[5];
    gsub(":","",cardid);

    if (!(cardid in cardids)) {
	numcardid += 1;
	cardidx[numcardid] = cardid;
	cardids[cardid] = cardid;
    }

    table[cardid,current] = $2;
}

END {
    line = "OTUID";
    for (i=1; i<=numsamp; i++) {
	line = line"\t"samples[i];
    }
    print line;

    for (j=1; j<=numcardid; j++) {
	line = cardidx[j];
	for (i=1; i<=numsamp; i++) {
	    value = (table[cardidx[j],samples[i]] == "") ? 0 : table[cardidx[j],samples[i]];
	    line = line"\t"value;
	}
	print line;
    }
}
