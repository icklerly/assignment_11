path <- "/Users/icklerly/Desktop/UNI/PROJECT/data/"
data <- read.csv(paste(path,"methylation_Flink.csv",sep=""),header=F,sep="\t",stringsAsFactors = F)
data <- read.csv(paste(path,"miRNA_Flink.csv",sep=""),header=F,sep="\t",stringsAsFactors = F)
data <- read.csv(paste(path,"mRNA_Flink.csv",sep=""),header=F,sep="\t",stringsAsFactors = F)

methyl<- read.csv(paste(path,"completed_methyl_Set.csv",sep=""),header=F,sep="\t",stringsAsFactors = F)

