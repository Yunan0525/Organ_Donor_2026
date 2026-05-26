BEGIN { FS="\t"; }

(NR==FNR)&&($4=="full") { remove[$1]=$1; }

(NR==FNR)&&($4=="partial")&&( ($3/$2) > 0.9 )  { remove[$1]=$1; }

(NR!=FNR)&&(/^>/) {

    split(substr($0,2),sa," ");
    id = sa[1];

    if (id in remove) {
	output = 0;
    } else {
	output = 1;
	print $0;
    }
}

(NR!=FNR)&&(!/^>/) {
    if (output) {
	print $0;
    }
}
