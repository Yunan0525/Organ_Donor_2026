BEGIN { FS="\t"; }

(NR==FNR) {
    parent[$1] = $3;
    node_level[$1] = $5;
}

(NR!=FNR)&&($3=="K") {
    kName[$2] = $1;
}

(NR!=FNR)&&($3=="P") {
    pName[$2] = $1;
}

(NR!=FNR)&&($3=="C") {
    cName[$2] = $1;
}

(NR!=FNR)&&($3=="O") {
    oName[$2] = $1;
}

(NR!=FNR)&&($3=="F") {
    fName[$2] = $1;
}

(NR!=FNR)&&($3=="G") {
    gName[$2] = $1;
}

(NR!=FNR)&&($3=="S") {
    key = $2;
    name = $1;
    gsub(" ","_",name);
    
    outline = "s__"name;
    while (key != 1) {
	if (key in gName) {
	    outline = "g__"gName[key]"; "outline;
	}
	if (key in fName) {
	    outline = "f__"fName[key]"; "outline;
	}
	if (key in oName) {
	    outline = "o__"oName[key]"; "outline;
	}
	if (key in cName) {
	    outline = "c__"cName[key]"; "outline;
	}
	if (key in pName) {
	    outline = "p__"pName[key]"; "outline;
	}
	if (key in kName) {
	    outline = "k__"kName[key]"; "outline;
	}
	
	key = parent[key];
    }

    print $1"\t"$2"\t"outline;
}

