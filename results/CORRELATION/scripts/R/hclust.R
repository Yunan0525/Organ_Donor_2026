args <- commandArgs(trailingOnly = TRUE)
dist.file <- paste(args[[1]], ".dist/distance-matrix.tsv", sep="");
out.file <- paste(args[[1]], ".clusters.txt", sep="");

write.table(cutree(hclust(as.dist(as.matrix(read.table(dist.file,sep="\t", header=T, row.names=1))),
		      method="ward.D"),
	           k=9),out.file, sep="\t")
