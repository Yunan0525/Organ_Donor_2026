BEGIN { FS="\t"; }

(!/INDEL/) && (!/^#/) && (FNR==NR) {

    meta = $8;

    len = split(meta,ma,";");
    depth = 0;
    for (i = 1; i<=len; i++) {
	if (substr(ma[i],1,3) == "DP=") {
	    depth = int(substr(ma[i],4));
	}

    }

    if (depth > DEPTH) {
	keep[$2]=$2;
    }
}

(/^#/) && (FNR!=NR) { print $0; }

(!/^#/) && (FNR!=NR) {

    if ($2 in keep) {

	meta = $8;

	len = split(meta,ma,";");
	map_qual = 0;
	for (i = 1; i<=len; i++) {
	    if (substr(ma[i],1,3) == "MQ=") {
		map_qual = int(substr(ma[i],4));
	    }
	}

	if (map_qual > MAP_QUAL) {
	    print $0;
	}

    }
}
