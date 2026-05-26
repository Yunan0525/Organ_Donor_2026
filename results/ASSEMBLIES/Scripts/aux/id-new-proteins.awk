BEGIN { FS = "\t"; }

/^>/&&(NR==FNR) {
    id = substr($0,2);
    keep[id] = id;
}

(NR!=FNR) {
    if ($2 in keep) {
	keepRep[$2] = $1;
    } else {
	existing[$1] = 1;
    }
}

END {
    for (i in keepRep) {
	novel = (existing[keepRep[i]] == 1) ? "EXISTING" : "NOVEL";
	print i"\t"keepRep[i]"\t"novel;
    }
}
