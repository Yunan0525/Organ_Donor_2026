BEGIN { FS="\t"; }

(NR==FNR)&&/=/ {
    split($0,sa1,"\"");
    len=split(sa1[2],sa2,",");

    for (i=1; i<=len; i++) {
	keep[sa2[i]]=sa2[i];
    }
    keep["9606"]="9606";
}

(NR!=FNR)&&(FNR==1) {
    len = split(FILENAME,sa,"/");
    outname = sa[len];

    if (sum != 0) {
	print outname"\t"sum;
    }
    sum = 0.0;
}

(NR!=FNR)&&(FNR>1) {
    if ($2 in keep) {
	sum += $7;
    }
}

END {
    print outname"\t"sum;
}
