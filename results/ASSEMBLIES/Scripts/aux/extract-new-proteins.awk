BEGIN { FS = "\t"; }

(NR==FNR)&&($3=="NOVEL") { keep[$1] = $1; }

/^>/&&(NR!=FNR) {
    id = substr($0,2);
    output = (id in keep) ? 1 : 0;
}

(NR!=FNR) {
    if (output) {
	print $0;
    }
}
