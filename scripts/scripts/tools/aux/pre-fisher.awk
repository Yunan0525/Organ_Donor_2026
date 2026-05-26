BEGIN { FS="\t"; }

(NR==FNR)&&(NR>1) { cat[$1]=$2; }

(NR!=FNR)&&(NF==5) {

    if (FNR==1) {
	vc["CLASS_A","A"]=0; vc["CLASS_A","T"]=0; vc["CLASS_A","G"]=0; vc["CLASS_A","C"]=0;
	vc["CLASS_B","A"]=0; vc["CLASS_B","T"]=0; vc["CLASS_B","G"]=0; vc["CLASS_B","C"]=0;
	ref["A"]=0; ref["T"]=0; ref["G"]=0; ref["C"]=0;
    }

    if ((FNR>1)&&( ($1 != prev_chrom) || ($2 != prev_site) )) {

	if ((ref["A"]*ref["T"] > 0) ||
	    (ref["A"]*ref["G"] > 0) ||
	    (ref["A"]*ref["C"] > 0) ||
	    (ref["T"]*ref["G"] > 0) ||
	    (ref["A"]*ref["C"] > 0) ||
	    (ref["G"]*ref["C"] > 0)) {
	    print "REF\t"prev_chrom"\t"prev_site"\t"ref["A"]"\t"ref["T"]"\t"ref["G"]"\t"ref["C"];
	}

	if ((vc["CLASS_A","A"]*vc["CLASS_A","T"] > 0) ||
	    (vc["CLASS_A","A"]*vc["CLASS_A","G"] > 0) ||
	    (vc["CLASS_A","A"]*vc["CLASS_A","C"] > 0) ||
	    (vc["CLASS_A","T"]*vc["CLASS_A","G"] > 0) ||
	    (vc["CLASS_A","T"]*vc["CLASS_A","C"] > 0) ||
	    (vc["CLASS_A","G"]*vc["CLASS_A","C"] > 0) ||
	    (vc["CLASS_B","A"]*vc["CLASS_B","T"] > 0) ||
	    (vc["CLASS_B","A"]*vc["CLASS_B","G"] > 0) ||
	    (vc["CLASS_B","A"]*vc["CLASS_B","C"] > 0) ||
	    (vc["CLASS_B","T"]*vc["CLASS_B","G"] > 0) ||
	    (vc["CLASS_B","T"]*vc["CLASS_B","C"] > 0) ||
	    (vc["CLASS_B","G"]*vc["CLASS_B","C"] > 0) ) {

	    line = prev_chrom"\t"prev_site"\tA\t"vc["CLASS_A","A"]"\t"vc["CLASS_A","T"];
	    line = line"\t"vc["CLASS_A","G"]"\t"vc["CLASS_A","C"]"\tB\t"vc["CLASS_B","A"];
	    line = line"\t"vc["CLASS_B","T"]"\t"vc["CLASS_B","G"]"\t"vc["CLASS_B","C"];
	    print line;
	}
	
	vc["CLASS_A","A"]=0; vc["CLASS_A","T"]=0; vc["CLASS_A","G"]=0; vc["CLASS_A","C"]=0;
	vc["CLASS_B","A"]=0; vc["CLASS_B","T"]=0; vc["CLASS_B","G"]=0; vc["CLASS_B","C"]=0;
	ref["A"]=0; ref["T"]=0; ref["G"]=0; ref["C"]=0;
    }

    var = ($5==".") ? $4 : $5;
    
    vc[cat[$3],var] += 1;
    ref[$4] += 1;
    
    prev_chrom = $1;
    prev_site = $2;

}

END {
    if ((vc["CLASS_A","A"]*vc["CLASS_A","T"] > 0) ||
	(vc["CLASS_A","A"]*vc["CLASS_A","G"] > 0) ||
	(vc["CLASS_A","A"]*vc["CLASS_A","C"] > 0) ||
	(vc["CLASS_A","T"]*vc["CLASS_A","G"] > 0) ||
	(vc["CLASS_A","T"]*vc["CLASS_A","C"] > 0) ||
	(vc["CLASS_A","G"]*vc["CLASS_A","C"] > 0) ||
	(vc["CLASS_B","A"]*vc["CLASS_B","T"] > 0) ||
	(vc["CLASS_B","A"]*vc["CLASS_B","G"] > 0) ||
	(vc["CLASS_B","A"]*vc["CLASS_B","C"] > 0) ||
	(vc["CLASS_B","T"]*vc["CLASS_B","G"] > 0) ||
	(vc["CLASS_B","T"]*vc["CLASS_B","C"] > 0) ||
	(vc["CLASS_B","G"]*vc["CLASS_B","C"] > 0) ) {
	
	line = prev_chrom"\t"prev_site"\tCLASS_A\t"vc["CLASS_A","A"]"\t"vc["CLASS_A","T"];
	line = line"\t"vc["CLASS_A","G"]"\t"vc["CLASS_A","C"]"\tImpair\t"vc["CLASS_B","A"];
	line = line"\t"vc["CLASS_B","T"]"\t"vc["CLASS_B","G"]"\t"vc["CLASS_B","C"];
	print line;
    }	
}
