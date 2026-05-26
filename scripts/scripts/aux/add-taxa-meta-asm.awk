BEGIN { FS="\t"; }

(NR==FNR) { taxa[$2]=$3; }

(NR!=FNR)&&(/^>/) {
    key = substr($0,2);

    taxaid = -1;
    if (key in taxa) {
	taxaid = taxa[key];
    }

    print $0""LABEL""taxaid;
}

(NR!=FNR)&&(!/^>/) { print $0; }

