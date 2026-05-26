library(ccrepe)

args <- commandArgs(trailingOnly = TRUE)

input.file <- paste(args[[1]], ".biom.txt", sep="");
df <- read.table(input.file, header=T, row.name=1, sep="\t");
df.in <- df/apply(df,1,sum)

df.out <- ccrepe(x=df.in, iterations=1000, min.subj=10)

output.file <- paste(args[[1]], ".sample.score.txt", sep="");
write.table(df.out$obs.sim.score, output.file, sep="\t");

output.file <- paste(args[[1]], ".sample.qvalue.txt", sep="");
write.table(df.out$q.values, output.file, sep="\t");

output.file <- paste(args[[1]], ".sample.pvalue.txt", sep="");
write.table(df.out$p.values, output.file, sep="\t");
