BEGIN { FS="\t"; }

(NR==FNR) {
    id = $1;

    ncbi[id] = $2;
    
    len = split($3,sa,"; ");

    for (i=1; i<=len; i++) {

	if (substr(sa[i],1,3) == "p__") {
	    p[id] = substr(sa[i],4);
	}

	if (substr(sa[i],1,3) == "c__") {
	    c[id] = substr(sa[i],4);
	}

	if (substr(sa[i],1,3) == "o__") {
	    o[id] = substr(sa[i],4);
	}

	if (substr(sa[i],1,3) == "f__") {
	    f[id] = substr(sa[i],4);
	}

	if (substr(sa[i],1,3) == "g__") {
	    g[id] = substr(sa[i],4);
	}

    }
}

(NR!=FNR)&&(FNR==1) { print $0"\tNCBI\tPhylum\tClass\tOrder\tFamily\tGenus"; }

(NR!=FNR)&&(FNR>1) {

    outp = ($1 in p) ? p[$1] : "NA";
    outc = ($1 in c) ? c[$1] : "NA";
    outo = ($1 in o) ? o[$1] : "NA";
    outf = ($1 in f) ? f[$1] : "NA";
    outg = ($1 in g) ? g[$1] : "NA";
    
    print $0"\t"ncbi[$1]"\t"outp"\t"outc"\t"outo"\t"outf"\t"outg;
}
