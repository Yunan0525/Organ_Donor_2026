BEGIN { FS="\t"; }

(NR==FNR) {  names[$2]=$3; ids[$2]=$1; }

(NR!=FNR)&&(!/^@/) {
    if ($3=="*") {
	name = "Unassembled";
	id = 0;
    } else {
	name = "Unclassified";
	id = 0;
	if ($3 in names) {
	    name = names[$3];
	    id = ids[$3];
	}
    }

    hist[name"|"id] += $2;
    total += $2;
}

END {
    for (name in hist) {
	split(name,sa,"|");
	output_name = sa[1];
	output_taxaid = sa[2];

	value = hist[name];
	frac = value/total;
	if (frac >= 0.00001) {
	    printf("%0.6f\t%d\t%s\t%s\n",frac,value,output_taxaid,output_name);
	} else {
	    other += value;
	}
    }
    printf("%0.6f\t%d\t-1\tOther\n",other/total,other);
}
