BEGIN { FS="\t"; }

(NR==FNR)&&($3 >= 0.15) { omit[$2]=$3; }
(NR==FNR)&&($3 <  0.15) { keep[$2]=$3; }

(NR!=FNR)&&(/^>/) {
    key = substr($0,2);
    
    if (key in omit) {
	output = 0;
    } else {
	
	split(key,sa,"_");

	score = 0;
	if (key in keep) {
	    score = keep[key];
	}
	print ">"sa[1]"_"sa[2]"_LEN_"sa[4]"_DM_"score;
	
	output = 1;
    }
}

(NR!=FNR)&&(!/^>/) {
    if (output) {
	print $0;
    }
}
