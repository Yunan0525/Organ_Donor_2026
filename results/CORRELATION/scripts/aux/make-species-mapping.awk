BEGIN { FS="\t"; }

(NR==1) { print "id\tsignif"; }

(NR>1) {
    n = 0;
    for (i=2; i<=NF; i++) {
	if ($i < 0.05) {
	    n += 1;
	}
    }

    id = $1;
    gsub("\"","",id);
   
    signif = (n >= 5) ? "YES" : "NO";

    print id"\t"signif;
}
