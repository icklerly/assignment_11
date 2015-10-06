#read in weights and names of genes
methyl <- read.csv(paste("/Users/icklerly/Desktop/UNI/PROJECT/flink-p/methyl_MLR_weights/3"),header=F,sep=",",stringsAsFactors = F)
set<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_methyl_Set.csv",sep="\t",header=T)

#completed <- read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_methyl_Flink.csv",sep="\t",header=F)
#names<-c("y",names)
#colnames(completed)<-names
#rownames(completed)<-rownames(set)
#write.table(completed,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_methyl_Set.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)

#sort weights and then extract the 10 highest features 
names<-colnames(set)[2:ncol(set)]

colnames(methyl)<-names
#take absoulte value for weights - can be negative or positive
sorted <- sort(abs(methyl))
maxis<-sorted[(length(sorted)-27):(length(sorted))]


set.seed(1)
shuffle <- set[sample(nrow(set)),]
y<-shuffle[,1]
sub<-shuffle[,colnames(maxis)]
sub <- cbind(y,sub)
sub<-sub[,-grep("NA..",colnames(sub))]

write.table(sub,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/methylation_subset.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(sub,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/methylation_subset_Flink.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)

