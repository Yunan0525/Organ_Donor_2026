BEGIN { FS="\t"; }

{
    if ($5=="PHG1") {
	color = "#AA0000DD";
    } else if ($5=="PHG2") {
	color = "#0000AADD";
    } else if ($5=="PHG3") {
	color = "#F27304DD";
    } else if ($5=="PHG4") {
	color = "#008000DD";
    } else if ($5=="PHG5") {
	color = "#91278DDD";
    } else if ($5=="PHG6") {
	color = "#AAAA00DD";
    } else if ($5=="PHG7") {
	color = "#00B6FFDD";
    } else if ($5=="PHG8") {
	color = "#80C99BDD";
    } else {
	color = "#A287BFDD";
    }

    print $0"\t"color;
}
