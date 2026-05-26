BEGIN { FS="\t"; }

(NR==FNR) {
    score[$1"-"$2] = $3;
    q[$1"-"$2] = $4;
}

(NR!=FNR)&&(($1"-"$2) in score) {
    s1 = score[$1"-"$2];
    s2 = $3;

    q1 = q[$1"-"$2];
    q2 = $4;

    q1 = (q1 > 1.0) ? 1.0 : q1;
    q2 = (q2 > 1.0) ? 1.0 : q2;
    
    diff = s1 - s2;
    
    print $1"\t"$2"\t"diff"\t"s1"\t"s2"\t"q1"\t"q2;
}
