BEGIN { FS="\t"; }

{
    qcov = $4/$3;
    
    if (($3>100) && ($4 > 45) && (qcov > 0.32) && ($5 < 1.0e-5)) {

	if ($5 > best[$1]) {
	    
	    fixed_hit=$2;
	    gsub(";",".",fixed_hit);
	    best_hit[$1]=fixed_hit;

	    best[$1]=$5;
	}
    }
}

END {
    for (i in best_hit) {
	quant[best_hit[i]] += 1;
    }

    for (i in quant) {
	print i"\t"quant[i];
    }
}
