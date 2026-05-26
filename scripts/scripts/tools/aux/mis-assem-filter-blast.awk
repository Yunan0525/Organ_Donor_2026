BEGIN { FS="\t"; }

{
    if ($4 > best[$2]) {
	    
	fixed_hit=$14;
	gsub(";",".",fixed_hit);
	best_hit[$2]=fixed_hit;
	id[$2] = $3;
	best[$2]=$4;
    }
}

END {
    sum = 0;
    for (i in best_hit) {
	print i"\t"best[i]"\t"id[i]"\t"best_hit[i];
	sum += best[i]; 
    }
    print "Total\t"sum;
}
