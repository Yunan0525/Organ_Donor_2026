/^>/ { meta=substr($0,2); }

!/^>/ {
    len=split($0,split_array,"N+");

    for (i=1; i<=len; i++) {
	if (length(split_array[i]) > 1000) {
		print ">"meta"-"i"\n"split_array[i];
	}
    }
}
