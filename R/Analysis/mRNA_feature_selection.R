#read in weights and names of genes
weights <- read.csv(paste("/Users/icklerly/Desktop/UNI/PROJECT/flink-p/mRNA_MLR_weights/3"),header=F,sep=",",stringsAsFactors = F)
mRNA<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/mRNA_Set.csv",sep="\t",header=T)

#completed <- read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_weights_Flink.csv",sep="\t",header=F)
#names<-c("y",names)
#colnames(completed)<-names
#rownames(completed)<-rownames(mRNA)
#write.table(completed,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_weights_mRNA.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)

#sort weights and then extract the 10 highest features 
names<-colnames(mRNA)[2:ncol(mRNA)]

colnames(weights)<-names
#take absoulte value for weights - can be negative or positive
sorted <- sort(abs(weights))
maxis<-sorted[(length(sorted)-24):(length(sorted))]

sub1<-mRNA[,colnames(maxis)]
sub1<-cbind(mRNA[,1],sub1)
sub2<-set[,colnames(maxis)]
sub2<-sub2[,-grep("NA..",colnames(sub2))]
for (i in 1:516){
  rownames(sub1)[i]<-paste("BRCA+",strsplit(rownames(sub1)[i],"\\+")[[1]][2],sep="")
}
mix<-merge(sub1, sub2, by = "row.names", all = F)
rownames(mix)<-mix[,1]
mix<-mix[,-1]
mix<-mix[-125:-121,]
write.table(mix,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/submixed_Set.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(mix,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/submixed_Flink.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)



mRNA.seed(1)
shuffle <- mRNA[sample(nrow(mRNA)),]
y<-shuffle[,1]
sub<-shuffle[,colnames(maxis)]
sub <- cbind(y,sub)
sub<-sub[,-grep("NA..",colnames(sub))]

write.table(sub,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/weightsation_submRNA.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(sub,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/weightsation_submRNA_Flink.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)

