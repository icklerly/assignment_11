#read in weights and names of genes
weights <- read.csv(paste("/Users/icklerly/Desktop/UNI/PROJECT/flink-p/mixed_MLR_weights/3"),header=F,sep=",",stringsAsFactors = F)
mixed<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/mixed_Set.csv",sep="\t",header=T)

#sort weights and then extract the 10 highest features 
names<-colnames(mixed)[2:ncol(mixed)]

colnames(weights)<-names
#take absoulte value for weights - can be negative or positive
sorted <- sort(abs(weights))
maxis<-sorted[(length(sorted)-21):(length(sorted))]


set.seed(1)
shuffle <- mixed[sample(nrow(mixed)),]
y<-shuffle[,1]
sub<-shuffle[,colnames(maxis)]
sub <- cbind(y,sub)
sub<-sub[,-grep("NA..",colnames(sub))]


write.table(sub,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/submixed_Set.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(sub,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/submixed_Flink.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)

