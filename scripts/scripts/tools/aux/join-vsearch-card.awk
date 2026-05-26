BEGIN { FS="\t"; }

(FNR == 1) {
    split(FILENAME,sa1,"/");
    split(sa1[3],sa2,".");
    sample = sa2[1];

    samples[sample] = sample;
}

(FNR > 1) {
    split($1,sa,"|");
    key = sa[6]" ["sa[5]"]";

    table[sample,key] = $2;
    keys[key] = key;
}

END {
    line = "CARD";
    for (sample in samples) {
	line = line"\t"sample;
    }
    print line;

    for (key in keys) {
	line = key;
	for (sample in samples) {
	    value = table[sample,key] ? table[sample,key] : 0;

	    line = line"\t"value;
	}
	print line;
    }
}
