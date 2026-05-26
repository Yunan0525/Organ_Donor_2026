BEGIN { FS="\t"; }

(NR==FNR) {
    split($1,sa,"|");
    key = sa[5];
    reads[key] = $2;
}

(NR!=FNR) {
    split(FILENAME,fnsa,"/");
    if (fnsa[1]=="EXTRACTs") {
	sample = substr(fnsa[4],1,8);
	species = fnsa[2];
    } else {
	sample = substr(fnsa[3],1,8);
	species = fnsa[1];
    }

    split($1,sa,"|");
    key = sa[3];

    if ((key in reads)&&(reads[key]>=10)&&($2>=10)) {
	print species"\t"sample"\t"key"\t"reads[key]"\t"$2"\t"sa[4];
    }
}
