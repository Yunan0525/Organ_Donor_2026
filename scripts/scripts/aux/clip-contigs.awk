BEGIN {
    FS="_";
    CLIP = (CLIP == 0) ? 1000 : CLIP;
 }

/^>NODE/ {
    if ($4>CLIP) {
	output = 1;
    } else {
	output = 0;
    }
}

{
    if (output) {
	print $0;
    }
}
