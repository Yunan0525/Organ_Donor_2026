BEGIN { FS=","; }

(NR==FNR)&&($4 >= 0.99) {
    len = split($1,sa,"/");
    key = sa[len];
    omit[key] = $4;
}
(NR==FNR)&&($4 <  0.99) {
    len = split($1,sa,"/");
    key = sa[len];
    keep[key] = $4;
}

(NR!=FNR)&&(/^>/) {
    key = substr($0,2);
    
    if (key in omit) {
	output = 0;
    } else {
	
	split(key,sa,"_");

	score = 0;
	if (key in keep) {
	    score = keep[key];
	    score_fmtd = sprintf("%.6f",score);
	}
	print ">"sa[1]"_"sa[2]"_LEN_"sa[4]"_RS_"score_fmtd;
	
	output = 1;
    }
}

(NR!=FNR)&&(!/^>/) {
    if (output) {
	print $0;
    }
}
