BEGIN { FS="\t"; }

(NR==1) {
    for (i=2; i<=NF; i++) {
	name = $i;
	gsub("\"","",name);
	print (i-2)"\t"name;
    }
}
