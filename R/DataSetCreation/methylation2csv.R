type <- "LUAD"
tumor <- 1
path <- paste("/Users/icklerly/Desktop/UNI/G-RIPS/RAW_DATA/",type,"\ -\ Methylation/DNA_Methylation/JHU_USC__HumanMethylation27/Level_3",sep="")
allFiles <- list.files(path)

features<-c(1:27579)
IDs <- c()
y <- c()

for (i in 1:length(allFiles)){
  splits <- strsplit(allFiles[i], "-")
  patID <- splits[[1]][5]
  
  new_col <- read.csv(paste(path,allFiles[i],sep="/"),header=TRUE,sep="\t",stringsAsFactors = FALSE)
  if(nrow(new_col)==27579){
    features <- rbind(features,new_col[,2]) #mRNA & miRNA: 2
    y<-c(y,tumor)
    IDs<-c(IDs,paste(type,patID,sep="+")) 
  }
}

features<-features[-1,]
features<-features[,-1]

all <- cbind(y,features)
rownames(all)<-IDs
colnames(all)[2:ncol(all)]<-new_col[2:nrow(new_col),3]

#get rid of the all columns that are total NaN
all<-all[, colSums(is.na(all)) != nrow(all)]

#replace NaNs with column mean - still 21989 Nas
for(i in 1:ncol(all)){
  all[is.na(all[,i]), i] <- mean(as.numeric(all[,i]), na.rm = TRUE)
}

meth<-all
meth<-meth[!(duplicated(rownames(meth))),]
#meth<-meth[,-1]
#uniqueMeth<-meth[!(duplicated(rownames(meth))),]
#uniquemiRNA<-miRNA[!(duplicated(rownames(miRNA))),]
#merge on patID - miRNA 63 patients - methylation 126 patients
#combined <- merge(uniquemiRNA, uniqueMeth, by="row.names", all=F)  # merge by row names (by=0 or by="row.names")
#rownames(combined)<-combined[,1]
#combined<-combined[,-1]

#write to file
#write.table(meth,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/",type,"_methylation_wNaN.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
BRCA_meth<-BRCA_meth[, colSums(is.na(BRCA_meth)) != nrow(BRCA_meth)]
LUAD_meth<-LUAD_meth[, colSums(is.na(LUAD_meth)) != nrow(LUAD_meth)]


write.table(meth,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/",type,"_methylation_wNaN.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)

BRCA_meth <- read.csv(paste("/Users/icklerly/Desktop/G-RIPS/RAW_DATA/\ BRCA\ _methylation.csv"),header=T,sep="\t",stringsAsFactors = F)
LUAD_meth <- read.csv(paste("/Users/icklerly/Desktop/G-RIPS/RAW_DATA/\ LUAD\ _methylation.csv"),header=T,sep="\t",stringsAsFactors = F)

min<- min(nrow(BRCA_meth),nrow(LUAD_meth))
meth_set <- rbind(BRCA_meth[1:min,],LUAD_meth[1:min,])

write.table(meth_set,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/methylation_Set_NaN.csv"),sep="\t",quote = FALSE,row.names=T,col.names =T)
write.table(meth_set,paste("/Users/icklerly/Desktop/UNI/PROJECT/data/methylation_Flink_NaN.csv"),sep="\t",quote = FALSE,row.names=F,col.names =F)

methyl <- read.csv(paste("/Users/icklerly/Desktop/1"),header=F,sep=",",stringsAsFactors = F)
methylnames<-read.csv("/Users/icklerly/Desktop/G-RIPS/RAW_DATA/methylation_Flink.csv",sep="\t",header=T)

meth <- read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/methylation_Set_NaN.csv",header=T,sep="\t",stringsAsFactors = F)
meth<-meth[,-1]

a<-0
for (i in 1:nrow(meth)){
  for (j in 1:ncol(meth)){
    if(is.na(meth[i,j])){
      a<-a+1
    }
    else{
      write.table(paste(i,j,round(meth[i,j], digits=5),sep=","),"/Users/icklerly/Desktop/UNI/PROJECT/data/NaN_Flink.csv",append=T,quote=F,row.names = F,col.names = F)
    }
  }
}
