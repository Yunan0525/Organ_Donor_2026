BEGIN { FS = "\t"; }

(NR==FNR)&&(FNR>1) {
    groups2[$3] = $3;
    group2[$1] = $3;
}

(NR!=FNR)&&(FNR>1) {
    groups1[$3] = $3;
    group1_sum[$3] += 1;
    
    if ($1 in group2) {
	accum[$3, group2[$1]] += 1;
    } else {
	accum[$3, "NULL"] += 1;
    }

}

END {
    line = "";
    for (j in groups2) {
	line = line"\t"j;
    }
    line = line"\tNULL";
    print line;

    for (i in groups1) {
	check = 0;
	line = i;
	for (j in groups2) {
	    line = line"\t"accum[i,j]/group1_sum[i];
	}
	line = line"\t"accum[i,"NULL"]/group1_sum[i];
	print line;
    }
}
