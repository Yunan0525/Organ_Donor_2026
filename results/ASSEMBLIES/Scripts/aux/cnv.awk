BEGIN { FS="\t"; }

{
    name[$2] = $2;
    quant[(NR>FNR),$2] = $1;
}

END {
    for (i in name) {
	val0 = quant[0,i];
	val1 = quant[1,i];
	if (val0 != val1) {
	    
	    print val0"\t"val1"\t"i;
	}
    }
}
