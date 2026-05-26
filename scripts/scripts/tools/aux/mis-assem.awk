BEGIN { FS="\t"; }

(NR==FNR) { names[$1]=$2; }

(NR!=FNR) {
    split($1,fa,"/");
    sample = fa[SAMPLE_POS];

    split($2,ma,"_");
    len = ma[4];
    kr_species = "UNCLASSIFIED";
    if (ma[8] in names) {
	kr_species = names[ma[8]];
    }
    bl_species = "UNCLASSIFIED";
    if (ma[10] in names) {
	bl_species = names[ma[10]];
    }

    output = ma[1]"_"ma[2]"_"ma[3]"_"ma[4];
    
    if (len > LEN_THRESH) {
	printf("%s\t%s\t%6.4f\t%s\t%s\n",sample,output,ma[6],kr_species,bl_species);
    }
}
