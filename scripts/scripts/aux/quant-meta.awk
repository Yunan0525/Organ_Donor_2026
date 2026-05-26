BEGIN { FS="\t"; }

(NR==FNR) {  taxa_names[$1]=$2; }

(NR!=FNR)&&(!/^@/) {
    if ($3=="*") {
	name = "Unassembled";
	id = -1;
    } else {
	name = "Unclassified";
	id = -1;

	split($3,sa,"_")
	id = sa[LABEL];

	if (id in taxa_names) {
	    name = taxa_names[id];
	}
    }

#    hist[name"|"id] += 0.5;
#    total += 0.5;
    hist[name"|"id] += (1.0 - exp((-$5/10.0)*log(10.0)))*0.5;
    total +=  (1.0 - exp((-$5/10.0)*log(10.0)))*0.5;
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
    printf("%0.6f\t%d\t-2\tOther\n",other/total,other);
}
