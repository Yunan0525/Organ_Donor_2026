BEGIN { FS="\t"; }

(FNR == 1) {
    split(FILENAME,sa,".");
    sample = sa[1];

    samples[sample] = sample;
}

(FNR > 1) {
    split($1,sa,"|");
    gene = sa[5];
    gsub(":","_",gene);

    genes[gene] = gene;    
    quant[sample, gene]= $2;
}

END {
    line = "Feature";
    for (sample in samples) {
	line = line"\t"sample;
    }
    print line;

    for (gene in genes) {
	line = gene;
	for (sample in samples) {
	    value = 0.0;
	    if (quant[sample,gene]) {
		value = quant[sample,gene];
	    }
	    line = line"\t"value;
	}
	print line;
    }
}
