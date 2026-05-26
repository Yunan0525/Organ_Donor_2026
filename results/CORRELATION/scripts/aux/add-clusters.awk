BEGIN { FS="\t"; }

(NR==FNR) {
    gsub("\"","",$1);
    cluster[$1] = LABEL""$2;
}

(NR!=FNR)&&(FNR==1) { print $0"\t"HEADER; }

(NR!=FNR)&&(FNR>1)&&($1 in cluster) { print $0"\t"cluster[$1]; }

(NR!=FNR)&&(FNR>1)&&(!($1 in cluster)) {
    unk += 1;
    print $0"\t"LABEL"X"unk;
}
