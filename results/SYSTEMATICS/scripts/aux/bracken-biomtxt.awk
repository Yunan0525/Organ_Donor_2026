BEGIN { FS="\t"; }

{
    if (NR==1) {
	printf("OTUID");
	for (i=4; i<=NF; i+=2) {
	    name=$i;
	    gsub(".bracken.out_num","",name);
	    printf("\t%s",name);
	}
	printf("\n");
    } else {
	sum = 0;
	for (i=4; i<=NF; i+=2) {
	    sum += $i;
	}

	if (sum > 20000) {
	    printf("%s",$1);
	    for (i=4; i<=NF; i+=2) {
		printf("\t%s",$i);
	    }
	    printf("\n");
	}
    }
}
