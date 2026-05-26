BEGIN { FS="\t"; }

{
    if ($5=="PHG1") {
	color = "#AA0000";
    } else if ($5=="PHG2") {
	color = "#0000AA";
    } else if ($5=="PHG3") {
	color = "#F27304";
    } else if ($5=="PHG4") {
	color = "#008000";
    } else if ($5=="PHG5") {
	color = "#91278D";
    } else if ($5=="PHG6") {
	color = "#AAAA00";
    } else if ($5=="PHG7") {
	color = "#00B6FF";
    } else if ($5=="PHG8") {
	color = "#80C99B";
    } else {
	color = "#A287BF";
    }

    if ($5 == SELECT) {
	color = color"FF";
    } else {
	color = "#AAAAAA44";
    }
    
    print $0"\t"color;
}
