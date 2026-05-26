BEGIN { FS="\t"; }

/^Homo sapiens/ { hs = $6; }

/^Toxoplasma gondii/ { tg = $6; }

END {
    pTg = 50.0*tg/(hs+tg);
    notTg = 0.0454*(1-pTg)/(0.0454*(1-pTg)+0.8973*pTg);
    print pTg"\t"notTg; }
