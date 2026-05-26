BEGIN { FS="\t"; }

(NR>2) {
    sample = $1;
    milieu = $8;
    tissue = $9;

    system("mkdir -p CORE-DIR/"milieu"-"tissue);
    system("cp -i ../BRACKEN/"sample".bracken.out CORE-DIR/"milieu"-"tissue);
    system("cp -i ../NON-HOST/HUMANN/"sample"/"sample"_ec_unstratified.tsv CORE-DIR/"milieu"-"tissue);
    system("cp -i ../NON-HOST/HUMANN/"sample"/"sample"_genefamilies-cpm_unstratified.tsv CORE-DIR/"milieu"-"tissue);
    system("cp -i ../NON-HOST/HUMANN/"sample"/"sample"_pathabundance_unstratified.tsv CORE-DIR/"milieu"-"tissue);
    system("cp -i ../NON-HOST/HUMANN/"sample"/"sample"_genefamilies-relab_unstratified.tsv CORE-DIR/"milieu"-"tissue);
    system("cp -i ../NON-HOST/HUMANN/"sample"/"sample"_ec-relab_unstratified.tsv CORE-DIR/"milieu"-"tissue);
    system("cp -i ../NON-HOST/HUMANN/"sample"/"sample"_pathabundance-relab_unstratified.tsv CORE-DIR/"milieu"-"tissue);

}
