BEGIN { FS="\t"; }

/^##bcftools_callCommand=call --ploidy 1 -m -Oz9 / {
    sample = $0;
    gsub("^.*/","",sample);
    gsub(".mpileup.vcf.gz;.*$","",sample);
}
(!/^#/) {
    print $1"\t"$2"\t"sample"\t"$4"\t"$5;
}
