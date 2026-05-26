BEGIN { FS="\t"; }

/^#/ { print $0; }

!/^#/ {

    label = $2;
    label = (label=="Protein Homology") ? "ProteinHomology" : label;

    type = $3;
    if ((type=="CDS") || (type=="exon")) {
	type = "CDS-EXON";
    }

    print $1"\t"label"\t"type"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9;

}
