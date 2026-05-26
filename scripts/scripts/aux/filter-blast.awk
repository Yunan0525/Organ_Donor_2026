BEGIN { FS="\t"; }

{
    split($1,name_array,"_");
    len = name_array[4];

    if (($13>80)&&(len > 1000)) {

	if ($4 > best[$1]) {
	    
	    fixed_hit=$14;
	    gsub(";",".",fixed_hit);
	    best_hit[$1]=fixed_hit;

	    best[$1]=$4;
	}
    }
}

END {
    for (i in best_hit) {
	print "BLAST\t"i"\t"best_hit[i];
    }
}
