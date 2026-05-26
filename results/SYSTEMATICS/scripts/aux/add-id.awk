BEGIN { FS="\t"; }

(NR==FNR) { id[$1]=$2; }

(NR!=FNR)&&(FNR==1) { print "name\ttaxonomy_id\ttaxonomy_lvl"; }

(NR!=FNR) { print $1"\t"id[$1]"\tS"; }
