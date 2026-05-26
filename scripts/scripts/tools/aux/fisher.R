
f <- file("stdin")
open(f)

while(length(line <- readLines(f,n=1)) > 0) {

  splitline <- strsplit(line, "\t"); 

  v <- as.numeric(c(splitline[[1]][4],  splitline[[1]][5],  splitline[[1]][6],  splitline[[1]][7],
           splitline[[1]][9], splitline[[1]][10], splitline[[1]][11], splitline[[1]][12]))

  fisher <- fisher.test(matrix(v,4,2))

  cat(fisher$p.value,"\t",line, "\n")

}
