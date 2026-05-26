BEGIN { FS="\t"; }

(NR==FNR)&&(NF==10)&&(!/^#/) {
    if ($5!=".") {
	variant[$2]=$4"/"$5;
    }
}	

(NR!=FNR)&&(NF==9)&&(($3=="CDS-EXON")||($3=="rRNA")||($3=="tRNA")||($3=="tmRNA")||($3=="ncNRA")) {
    len = split($9,meta_array,";");
    for (i=1; i<=len; i++) {
	if (substr(meta_array[i],1,8)=="product=") {
	    product = substr(meta_array[i],9);
	}
    }

    # This is not exactly super efficient
    for (var in variant) {
	pos = var + 0;  lower = $4+0;  upper = $5+0;
	if ((pos >= lower) && (pos <= upper)) {
	    print TAG1"\t"TAG2"\t"$1"\t"var"\t"$4"\t"$5"\t"variant[var]"\t"product;
	    delete variant[var] ;
	}
    }
}

END {
    for (var in variant) {
	print TAG1"\t"TAG2"\tNF\t"var"\tNF\tNF\t"variant[var]"\tNF";
    }
}
