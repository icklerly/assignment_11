#convert results from Flink-ALS back to completed matrix
#cat /Users/icklerly/Desktop/UNI/PROJECT/flink-ALS/output_meth/itemFactorsFile/* > items.txt
#cat /Users/icklerly/Desktop/UNI/PROJECT/flink-ALS/output_meth/userFactorsFile/* > users.txt
#read first file
user <- read.csv("/Users/icklerly/Desktop/UNI/PROJECT/flink-ALS/output_meth/users.txt",header=F,sep=",",stringsAsFactors = F)
#get rid of parantheses
user$V1<-gsub("\\(","",user$V1)
user$V3<-gsub("\\)","",user$V3)
patients<- matrix(nrow=nrow(user),ncol=ncol(user)-1)
for (i in 1:nrow(user)){
  patients[as.numeric(user[i,1]),1]<-as.numeric(user[i,2])
  patients[as.numeric(user[i,1]),2]<-as.numeric(user[i,3])
}

#read second file
item <- read.csv("/Users/icklerly/Desktop/UNI/PROJECT/flink-ALS/output_meth/items.txt",header=F,sep=",",stringsAsFactors = F)
#get rid of parantheses
item$V1<-gsub("\\(","",item$V1)
item$V3<-gsub("\\)","",item$V3)
features<- matrix(nrow=ncol(item)-1,ncol=nrow(item))
for (i in 1:nrow(item)){
  features[1,as.numeric(item[i,1])]<-as.numeric(item[i,2])
  features[2,as.numeric(item[i,1])]<-as.numeric(item[i,3])
}
#calculate completed matrix
completed<-patients%*%features
#add labels
completed<-cbind(c(rep(-1,126),rep(1,126)),completed) 
#write to file
write.table(completed,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_methyl_Set.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(completed,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/completed_methyl_Flink.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)

path <- "/Users/icklerly/Desktop/UNI/PROJECT/data/"
methyl<- read.csv(paste(path,"completed_methyl_Flink.csv",sep=""),header=F,sep="\t",stringsAsFactors = F)

#read file with means to compare
set<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/methylation_Set.csv",sep="\t",header=T)
