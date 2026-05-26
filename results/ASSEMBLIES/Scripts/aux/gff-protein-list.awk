BEGIN { FS="\t"; }

/^^##FASTA/ { stop_output = 1; }

!/^#/ {

    if (! stop_output) {

	product = "";
	translation = "";
	len = split($9,sa,";");
	for (i=1; i<=len; i++) {
	    if (substr(sa[i],1,8) == "product=") {
		product = substr(sa[i],9);
		gsub(" ","_",product);
	    }
	    if (substr(sa[i],1,12) == "translation=") {
		translation = substr(sa[i],13);
	    }
	}

	if ((product != "")&&(translation != "")) {
	    print ">"$1"-"$4"-"$5"|"product;
	    print translation;
	}
    }
}
