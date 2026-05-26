BEGIN { FS=" "; }

(/^>/) {
    if (NR > 1) {
	print name"\t"len;
    }
    len = 0;
    name = substr($1,2);
}

!/^>/ {
    len += length($0);
}

END {
    print name"\t"len;
}
