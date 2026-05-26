BEGIN { FS="\t"; }

{
    len = split($2,sa,"; ");
    
    taxa = "Unnamed";
    parent = "Unnamed";
    
    for (i=1; i<=len; i++) {
	phylokey = substr(sa[i],1,1);

	if (phylokey == "g") {
	    taxa = sa[i];
	    gsub("^.__","",taxa);
	    gsub("_"," ",taxa);
	}

	if (phylokey == "f") {
	    parent = sa[i];
	    gsub("^.__","",parent);
	    gsub("_"," ",parent);
	}
    }

    print $1"\t"taxa" Parent: "parent;
    #print $1"\t"taxa;
}
