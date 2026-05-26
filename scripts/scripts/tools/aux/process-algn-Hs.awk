BEGIN { FS=" "; }

(NR==1) { print "SampleName\tSp & Hs\tSp & NoHs\tNoSp & Hs\tNoSp & NoHs"; }

(NR % 6 == 1) { samplename = $1; }

(NR % 6 == 2) {
    gsub("%","",$1);
    align1 = $1/100.0;
    noalign1 = 1.00 - align1;
}

(NR % 6 == 4) {
    gsub("%","",$1);
    noalign1_align2 = noalign1*($1/100.0);
    noalign1_noalign2 = noalign1*(1.0 - $1/100.0);
}

(NR % 6 == 0) {
    gsub("%","",$1);
    align1_align2 = align1*($1/100.0);
    align1_noalign2 = align1*(1.0 - $1/100.0);

    sum = align1_align2+align1_noalign2+noalign1_align2+noalign1_noalign2;
    print samplename"\t"align1_align2"\t"align1_noalign2"\t"noalign1_align2"\t"noalign1_noalign2"\t"sum;
}
