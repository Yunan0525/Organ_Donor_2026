BEGIN { FS="\t"; }

(FNR==NR) { keep[$1]=$1; }

(FNR!=NR)&&(FNR==1) {
    print "Species1\tSpecies2\tValues";
    for (i=1; i<=NF; i++) {
	name[i+1] = $i;
    }
}

(FNR!=NR)&&(FNR>1) {
    for (i=2; i<=NF; i++) {
	
	species1 = $1;
	gsub("\"","",species1);

	species2 = name[i];
	gsub("\"","",species2);

	value = ($i == "NA") ? 1.0 : $i;
	
	if ((species1 in keep) && (species2 in keep)) {
	    print species1"\t"species2"\t"value;
	}
    }
}
