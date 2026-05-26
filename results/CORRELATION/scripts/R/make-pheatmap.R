library(RColorBrewer)
library(pheatmap)

args <- commandArgs(trailingOnly = TRUE)
corr.file <- paste(args[[1]], ".score.txt", sep="");
df <- read.table(corr.file, sep="\t", header=T, row.names=1)

out.file <- paste(args[[1]], ".pdf", sep="");
out.dendro.file <- paste(args[[1]], ".pheatmap.clusters.txt", sep="")

pdf(out.file, height=300, width=300)

phm <- pheatmap(df, show_rownames=T, show_colnames=T,
         height=10000, width=10000, treeheight_row=2500, treeheight_col=2500, fontsize=128,
	 cellheight = 200, cellwidth = 200, legend=F,
	 color = colorRampPalette(rev(brewer.pal(n = 11, name = "RdBu")))(100))
phm
dev.off()

write.table(cutree(phm$tree_row,k=9),out.dendro.file, sep="\t")
