library(ggplot2)
library(ggrepel)
library(reshape2)
###gene proportion
gene<- read.table("gene_freq.txt",head=T,check.names = F)
gene$gene_num <- prettyNum(gene$gene_num,big.mark = ",")
gene$label <- rep("NA",6)
gene$label[1:5] <- paste(round(gene$gene_percent[1:5],digits = 1),"%",sep = "")
gene$label[6] <- paste(round(gene$gene_percent[6],digits = 2),"%",sep = "")
ggplot(gene[-2,],aes(x=Sample_percent,y=gene_percent,group=1))+
geom_line() +
geom_point()+
labs(x="The proportion of samples (%)",y="The proportion of genes (%)")+
theme_bw()+
theme(panel.grid=element_blank(),
panel.background = element_rect(color = "black"),
axis.title.y = element_text(size = 12,color="black"),
axis.title.x = element_text(size = 12,color="black"),
axis.text.y = element_text(size = 11,color="black"),
axis.text.x = element_text(size = 11,color="black")) +
geom_vline(aes(xintercept = 0),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 20),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 50),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 90),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 100),linetype="dashed",colour="grey") +
scale_x_continuous(breaks = c(0,20,50,90,100)) +
geom_text_repel(aes(label=paste(gene_num,"(",label,")",sep = "")),size = 2.6)
ggsave("gene_proportion_line.pdf",height=3.5,width=3.5)

#######taxa proportion
taxa_num<-read.table("taxa_num.txt",header = T,sep = "\t",check.names = F,stringsAsFactors = F) #The numbers of taxa shared in samples
taxa_freq<-read.table("taxa_freq.txt",header = T,sep = "\t",check.names = F,stringsAsFactors = F) #The frequency of taxa shared in samples

taxa_num_melt <- melt(taxa_num,id.vars = "Sample_num")
head(taxa_num_melt)
taxa_freq_melt <- melt(taxa_freq,id.vars = "Sample_percent")
taxa_freq_melt$absolute <- taxa_num_melt$value
taxa_freq_melt$variable <- factor(taxa_freq_melt$variable,levels = c("Phylum","Genus","Species"))
taxa_freq_melt$percent <- paste(round(taxa_freq_melt$value,digits = 0),"%",sep = "")
head(taxa_freq_melt$percent)
ggplot(taxa_freq_melt,aes(x=Sample_percent,y=value,colour=variable,group=variable))+
geom_line() +
geom_point() +
labs(x="The proportion of samples (%)",y="The proportion of shared items (%)")+
theme_bw()+
theme(panel.grid=element_blank(),
panel.background = element_rect(color = "black"),
legend.position=c(0.15,0.11),
#legend.key = element_rect(fill = NULL,colour = NULL),
legend.title = element_blank(),
legend.text = element_text(size = 8,color="black"),
legend.key.height=unit(0.4, "cm"),
axis.title.y = element_text(size = 12,color="black"),
axis.title.x = element_text(size = 12,color="black"),
axis.text.y = element_text(size = 11,color="black"),
axis.text.x = element_text(size = 11,color="black")) +
geom_vline(aes(xintercept = 0),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 20),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 50),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 90),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 100),linetype="dashed",colour="grey") +
scale_x_continuous(breaks = c(0,20,50,90,100)) +
geom_text_repel(aes(label=paste(absolute,"(",percent,")",sep = "")),size = 2.6)
ggsave("taxa_proportion_line.pdf",height=3.5,width=3.5)

###Function proportion
func_num<-read.table("BWA_func_num.txt",header = T,sep = "\t",check.names = F,stringsAsFactors = F)
func_freq<-read.table("BWA_func_freq.txt",header = T,sep = "\t",check.names = F,stringsAsFactors = F)
func_num_melt <- melt(func_num,id.vars = "Sample_num")
func_freq_melt <- melt(func_freq,id.vars = "Sample_percent")
func_freq_melt$absolute <- func_num_melt$value
func_freq_melt$variable <- factor(func_freq_melt$variable,levels = c("CAZy family","KEGG pathway","KO", "eggNOG ortholog"))
func_freq_melt$percent <- paste(round(func_freq_melt$value,digits = 0),"%",sep = "")
func_freq_melt$percent[20]<-"0.3%"
func_freq_melt$percent
ggplot(func_freq_melt,aes(x=Sample_percent,y=value,colour=variable,group=variable))+
geom_line() +
geom_point() +
labs(x="The proportion of samples (%)",y="The proportion of shared items (%)")+
theme_bw()+
theme(panel.grid=element_blank(),
panel.background = element_rect(color = "black"),
legend.position=c(0.75,0.84),
#legend.key = element_rect(fill = NULL,colour = NULL),
legend.title = element_blank(),
legend.text = element_text(size = 8,color="black"),
legend.key.height=unit(0.36, "cm"),
axis.title.y = element_text(size = 12,color="black"),
axis.title.x = element_text(size = 12,color="black"),
axis.text.y = element_text(size = 11,color="black"),
axis.text.x = element_text(size = 11,color="black")) +
geom_vline(aes(xintercept = 0),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 20),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 50),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 90),linetype="dashed",colour="grey")+
geom_vline(aes(xintercept = 100),linetype="dashed",colour="grey") +
scale_x_continuous(breaks = c(0,20,50,90,100)) +
geom_text_repel(aes(label=paste(absolute,"(",percent,")",sep = "")),size = 2.6)
ggsave("func_proportion_line.pdf",height=3.5,width=3.5)