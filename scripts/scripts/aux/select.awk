BEGIN {
    FS="\t";
    len = split(SS,species_list,",");
    for (i=1; i<=len; i++) {
	species_name = species_list[i];
	species[species_name]=species_name;
    }
}

(NR==FNR) {
    if ($3 in species) {
	keep[$2]=1;
    }
}

(NR!=FNR) {
    if (FNR % 4 == 1) {
	split($0,line_array," ");
	key=substr(line_array[1],2);
	if (key in keep) {
	    out = 1;
	    print $0;
	} else {
	    out = 0;
	}
    } else {
	if (out) {
	    print $0;
	}
    }
}
