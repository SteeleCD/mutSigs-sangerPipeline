#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# bulkFile, outFile, projectName
# read bulk file
data = read.table(args[1],sep="\t")
data = data[which(data[,16]=="Sub"),]
out = cbind(args[3],data[,2],args[3],"GRCh37","subs",data[,c(5,6,6,7,8)],"SOMATIC")
write.table(out,file=args[2],sep="\t",col.names=FALSE,row.names=FALSE,quote=FALSE)
