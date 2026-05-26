BEGIN { FS="\t"; }

(NR==FNR) {
    key = "";
    if ($4>100) {
	split($2,sa,"|");
	key = sa[5];
	gsub(":","-",key);
	outputs[$1] = key;
    }
}

(NR!=FNR)&&((FNR % 4)==1)  {
    split($1,sa," ");
    key = substr(sa[1],2);
    output = (key in outputs) ? "NON-HOST/AMR-FASTQs/"SAMPLE"/"SAMPLE"-"outputs[key]"_"READ".fastq" : "NON-AMR";
}

(NR!=FNR)&&(output != "NON-AMR")  { print $0 > output; }
