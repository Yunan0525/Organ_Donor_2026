BEGIN { FS="\t"; }

/^Homo sapiens/ { hs = $6; }

/^Toxoplasma gondii/ { tg = $6; }

END {
    pTg = 50.0*tg/(hs+tg);
    Tg = 0.1027*(pTg)/((1-0.0454)*(1-pTg)+0.1027*pTg);
    print pTg"\t"Tg;
}
