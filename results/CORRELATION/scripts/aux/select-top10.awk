BEGIN { FS="\t"; }

(NR==FNR) {
    key = $1;
    gsub("\"","",key);
    clusters[key] = $2;
}

(NR!=FNR) {
    key = $1;
    cluster = clusters[key];
    sofar[cluster] = (cluster in sofar) ? sofar[cluster]+1 : 1;
    if (sofar[cluster] <= 10) {
	print key"\t"cluster;
    }
}
