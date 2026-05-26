BEGIN { FS="\t"; }

(NR>1) {
    cmd = "echo "$1"; grep '"$1"' *.nwk | wc -l";
    system(cmd);
}
