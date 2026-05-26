BEGIN { FS="|"; }

(NR==FNR) { taxaid[$2]=$2; }

(NR!=FNR) {
    split($0,sa,"\t");
    if (!(sa[1] in taxaid)) {
	print $0;
    }
}
