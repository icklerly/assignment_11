methyl<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_methyl_Set.csv",sep="\t",header=T)
mRNA<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/mRNA_Set.csv",sep="\t",header=T)
for (i in 1:516){
  rownames(mRNA)[i]<-paste("BRCA+",strsplit(rownames(mRNA)[i],"\\+")[[1]][2],sep="")
}

#merge the two data types by their row names
#Merge them together
mix<-merge(methyl, mRNA[,-1], by = "row.names", all = F)
rownames(mix)<-mix[,1]
mix<-mix[,-1]
mix<-mix[-125:-121,]

write.table(mix,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/mixed_Set.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(mix,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/mixed_Flink.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)
