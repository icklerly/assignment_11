type <- "LUAD"
tumor <- 1
path <- paste("/Users/icklerly/Desktop/G-RIPS/RAW_DATA/",type,"\ -\ mRNA/RNASeqV2/UNC__IlluminaHiSeq_RNASeqV2/Level_3/",sep="")
allFiles <- list.files(path,pattern=c("*genes.normalized_results"))

features<-c(1:20502)
IDs <- c()
y <- c()

for (i in 1:length(allFiles)){
  splits <- strsplit(allFiles[i], "-")
  patID <- splits[[1]][3]
  
  new_col <- read.csv(paste(path,allFiles[i],sep="/"),header=TRUE,sep="\t",stringsAsFactors = FALSE)
  if(nrow(new_col)==1046){
    features <- rbind(features,new_col[,2]) #mRNA & miRNA: 2
    y<-c(y,tumor)
    IDs<-c(IDs,paste(type,patID,sep="+")) 
  }
}

features<-features[-1,]
all <- cbind(y,features)
rownames(all)<-IDs
colnames(all)[2:ncol(all)]<-new_col[,1]
miRNA<-all
miRNA<-miRNA[!(duplicated(rownames(miRNA))),]

#get rid of the ?
#all <- all[,-(c(2:30))]
#all2 <- all2[,-(c(2:30))]

write.table(all,paste("/Users/icklerly/Desktop/G-RIPS/RAW_DATA/",type,"_mRNA.csv"),sep="\t",quote = FALSE,row.names=FALSE,col.names =FALSE)