BEGIN { FS="\t"; }

(NR==FNR)&&/=/ {
    split($0,sa1,"\"");
    len=split(sa1[2],sa2,",");

    for (i=1; i<=len; i++) {
	keep[sa2[i]]=sa2[i];
    }
    keep["9606"]="9606";
}

(NR!=FNR)&&(FNR>1) {
    if (!($2 in keep)) {
	if ($7>THRESH) {
	    print FILENAME":"$7"\t"$1;
	}
    }
}


