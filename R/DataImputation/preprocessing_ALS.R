mRNA<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/mRNA_Set.csv",sep="\t",header=T)
names<-colnames(mRNA)

mRNA<-mRNA[,-1]
coexpression<-cor(mRNA)
coexpression[coexpression >= 0.8] <- 1
coexpression[coexpression < 0.8] <- 0
logFile = "/Users/icklerly/Desktop/UNI/PROJECT/data/mRNA_edges.txt"
cat("#this is a file containing the edges", file=logFile, append=FALSE, sep = "\n")

for(i in 1:ncol(coexpression)){
  for(j in 1:i){
    if(!(i==j) & !(coexpression[i,j]==0) & !(is.na(coexpression[i, j]))){
      cat(paste(i,"\t",j,"\t",formatC(coexpression[i,j], digits = 1, format = "f"),sep=""), file=logFile, append=TRUE, sep = "\n")
    }
    
  }
}

cluster <- read.csv("/Users/icklerly/Desktop/UNI/PROJECT/mRNA_communities.csv",header=F,sep=",",stringsAsFactors = FALSE)
#69, 391, 126, 99, 4515
geneList1<-c()
for(i in 1:nrow(cluster)){  #nrow(cluster)
  if(cluster[i,2]==69)
    geneList1<-c(geneList1,unlist(strsplit(names[cluster[i,1]], "|",fixed = TRUE))[1])
}

sparse<-read.csv("/Users/icklerly/Desktop/UNI/PROJECT/data/submixed_Set.csv",sep="\t",header=T)
namesS<-colnames(sparse)[2:51]
write(paste(geneList1, collapse = "\n"),"/Users/icklerly/Desktop/UNI/PROJECT/geneList.txt")

