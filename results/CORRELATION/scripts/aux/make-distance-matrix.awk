BEGIN { FS = "\t"; }

(NR==1) {
    line = "\t"$0;
    gsub("\"","",line);
    print line;
}

(NR!=1) {
    line = $1;
    gsub("\"","",line);
    for (i=2; i<=NF; i++) {
	distance = 0.0;
	if ($i != "NA") {
	    distance = sqrt(2.0 - 2.0*$i);
	}
	line = line"\t"distance;
    }
    print line;
}
