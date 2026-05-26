BEGIN { FS="\t"; }

(NR>1) {
    id = $1;
    split(id,sa,".");

    key = sa[1]"."sa[2]"."sa[3];

    if (key in l1) {
	l1[key] = l1[key]", "id;
    } else {
	l1[key] = id;
    }
}

END {
    for (id in l1) {
	l1[id] = "("l1[id]")"id;
    }
    
    for (id in l1) {
	split(id,sa,".");

	key = sa[1]"."sa[2];

	if (key in l2) {
	    l2[key] = l2[key]", "l1[id];
	} else {
	    l2[key] = id;
	}	
    }

    for (id in l2) {
	l2[id] = "("l2[id]")"id;
    }

    for (id in l2) {
	split(id,sa,".");

	key = sa[1];

	if (key in l3) {
	    l3[key] = l3[key]", "l2[id];
	} else {
	    l3[key] = id;
	}	
   }

    for (id in l3) {
	l3[id] = "("l3[id]")"id;
    }

    newick = "";
    for (id in l3) {
	if (newick == "") {
	    newick = "("l3[id];
	} else {
	    newick = newick", "l3[id];
	}
    }
    newick = newick");"

    print newick;

}
