BEGIN { FS="\t"; }

(NR % 4 == 1) {
    if (rand() < 0.5) {
	output = 1;
    } else {
	output = 2;
    }
}

{
    print $1 >> KEY"_L00"output"_R1.fastq";
    print $2 >> KEY"_L00"output"_R2.fastq";
}
