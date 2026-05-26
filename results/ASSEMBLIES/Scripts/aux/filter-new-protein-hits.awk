BEGIN { FS="\t"; }

{
    pident = $3
    len = $4;
    evalue = $11;
    bitvalue = $12;
    
    if ((pident>90.0) && (len > 100)) {

	if ( (1.0 - evalue) > best[$1]) {
	    
	    fixed_hit=$2;
	    gsub(";",".",fixed_hit);
	    best_hit[$1] = fixed_hit;

	    best[$1] = (1.0 - evalue);
	    evalues[$1] = evalue;
	}
    }
}

END {
    for (i in best_hit) {
	print i"\t"best_hit[i]"\t"evalues[i];
    }
}
