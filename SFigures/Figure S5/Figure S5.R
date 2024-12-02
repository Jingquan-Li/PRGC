###Figure S5C
spec_lung <- read.table("lung_species.tab" ,header=T,row.names=1, sep="\t",check.names=F,quote="")
spec_trachea <- read.table("trachea_species.tab" ,header=T,row.names=1, sep="\t",check.names=F,quote="")
spec_lung_mean <- apply(spec_lung,1 , mean)
spec_lung_top20<- spec_lung[order(spec_lung_mean,decreasing = T)[1:20],]
spec_lung_top20_log <- log10(spec_lung_top20)
spec_trachea_mean <- apply(spec_trachea,1 , mean)
spec_trachea_top20<- spec_trachea[order(spec_trachea_mean,decreasing = T)[1:20],]
spec_trachea_top20_log <- log10(spec_trachea_top20)
trachea_uniq <- setdiff(rownames(spec_trachea_top20),rownames(spec_lung_top20))
length(trachea_uniq)
rep <- rep(NA,ncol(spec_lung_top20))
top20_lung_add <- rbind(spec_lung_top20_log, rep,rep,rep,rep,rep,rep,rep)
rownames(top20_lung_add)[21:27] <- trachea_uniq
top20_lung_add$spec_hlies <- rownames(top20_lung_add)
library(reshape2)
top20_lung_add.melt <- melt(top20_lung_add)
library(ggplot2)
ggplot(top20_lung_add.melt, aes(x=spec_hlies, y=value))+ geom_boxplot(fill="#0073C2", outlier.size=0.6)+coord_flip()+scale_x_discrete(limits=rev(levels(top20_lung_add.melt$spec_hlies)))+scale_y_continuous(breaks=c(-6,-5,-4,-3,-2))+labs(y="Relative abundance (log10)",x=NULL)+theme_bw()+theme(panel.grid.major = element_blank(),plot.title = element_text(hjust = 0.5),axis.text.x = element_text(size = 9,color="black"),axis.text.y = element_text(size = 9,color="black"),axis.title.x = element_text(size = 9,color="black"))
ggsave("lung_top20_combine.pdf",width=3.5,height=5)
lung_uniq <- setdiff(rownames(spec_lung_top20),rownames(spec_trachea_top20))
rep <- rep(NA,ncol(spec_trachea_top20))
top20_trachea_add <- rbind(spec_trachea_top20_log, rep,rep,rep,rep,rep,rep,rep)
rownames(top20_trachea_add)[21:27] <- lung_uniq
top20_trachea_add$spec_svllies <- rownames(top20_trachea_add)
top20_trachea_add.melt <- melt(top20_trachea_add)
ggplot(top20_trachea_add.melt, aes(x=spec_svllies, y=value))+ geom_boxplot(fill="#EFC000", outlier.size=0.6)+coord_flip()+scale_x_discrete(limits=rev(levels(top20_trachea_add.melt$spec_hlies)))+scale_y_continuous(breaks=c(-6,-5,-4,-3,-2))+labs(y="Relative abundance (log10)",x=NULL)+theme_bw()+theme(panel.grid.major = element_blank(),plot.title = element_text(hjust = 0.5),axis.text.x = element_text(size = 9,color="black"),axis.text.y = element_text(size = 9,color="black"),axis.title.x = element_text(size = 9,color="black"))
ggsave("trachea_top20_combine.pdf",width=3.5,height=5)
