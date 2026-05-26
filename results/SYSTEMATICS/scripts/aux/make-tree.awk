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
    while ( (!(key in gName)) && (key != 1)) {
	key = parent[key];
    }
    if (key==1) {
	if (outgroups) {
	    outgroups = outgroups","$1;
	} else {
	    outgroups = $1;
	}
    } else {    
	if (key in gTree) {
	    gTree[key] = gTree[key]","$1
	} else {
	    gTree[key] = $1;
	}
    }
}

END {

    for (i in gTree) {
	gTree[i] = "("gTree[i]")"gName[i];
	key = i;
	while ( (!(key in fName)) && (key != 1)) {
	    key = parent[key];
	}
	if (key==1) {
	    if (outgroups) {
		outgroups = outgroups","gTree[i];
	    } else {
		outgroups = gTree[i];
	    }
	} else {    
	    if (key in fTree) {
		fTree[key] = fTree[key]","gTree[i];
	    } else {
		fTree[key] = gTree[i];
	    }
	}
    }

    for (i in fTree) {
	fTree[i] = "("fTree[i]")"fName[i];
	key = i;
	while ( (!(key in oName)) && (key != 1)) {
	    key = parent[key];
	}
	if (key==1) {
	    if (outgroups) {
		outgroups = outgroups","fTree[i];
	    } else {
		outgroups = fTree[i];
	    }
	} else {    
	    if (key in oTree) {
		oTree[key] = oTree[key]","fTree[i];
	    } else {
		oTree[key] = fTree[i];
	    }
	}
    }

    for (i in oTree) {
	oTree[i] = "("oTree[i]")"oName[i];
	key = i;
	while ( (!(key in cName)) && (key != 1)) {
	    key = parent[key];
	}
	if (key==1) {
	    if (outgroups) {
		outgroups = outgroups","oTree[i];
	    } else {
		outgroups = oTree[i];
	    }
	} else {    
	    if (key in cTree) {
		cTree[key] = cTree[key]","oTree[i];
	    } else {
		cTree[key] = oTree[i];
	    }
	}
    }

    for (i in cTree) {
	cTree[i] = "("cTree[i]")"cName[i];
	key = i;
	while ( (!(key in pName)) && (key != 1)) {
	    key = parent[key];
	}
	if (key==1) {
	    if (outgroups) {
		outgroups = outgroups","cTree[i];
	    } else {
		outgroups = cTree[i];
	    }
	} else {    
	    if (key in pTree) {
		pTree[key] = pTree[key]","cTree[i];
	    } else {
		pTree[key] = cTree[i];
	    }
	}
    }

    for (i in pTree) {
	pTree[i] = "("pTree[i]")"pName[i];

	if (outgroups) {
	    outgroups = outgroups","pTree[i];
	} else {
	    outgroups = pTree[i];
	}
    }

    print "("outgroups")";
}
