###Figure 1A
library(data.table)
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(grid)
library(stats)
library(ggthemes) 
pre <- read.table("gene_bwa_relative_test.txt", row.names = 1,header = T, check.names = F,quote="",stringsAsFactors=FALSE)
###convert gene abundance to 0 or 1
pre <- (pre[,1:ncol(pre)] !=0)*1
#bact <- pre

subsampling = seq(1,ncol(pre), 10)
dset.subsamp = data.frame(matrix(0,length(subsampling),4))
#####sample from 1 to ncol(bact) 
reps = 10
for (i in 1:length(subsampling)){
	    rep = c(rep(0,reps))
    for (n in 1:reps){
	            cols = sample(colnames(pre),subsampling[i])
            if (length(cols)<=1){rep[n] = length(which(pre[,cols] > 0))}
	            else  {rep[n] = length(which(rowSums(pre[,cols]) > 0))}
    }
        dset.subsamp[i,1] = subsampling[i]
        dset.subsamp[i,2] = mean(rep)
	    dset.subsamp[i,3] = sd(rep)
}
colnames(dset.subsamp) = c("Samples", "Species", "SD", "Origin")
dset.subsamp$Origin = "Lung"
print(ggplot(dset.subsamp, aes(x=Samples, y=Species, colour=Origin))
      + geom_smooth(method="nls", formula=y~SSasymp(x, Asym, R0, lrc), se=F, size=0.35)
      + geom_point(size=0.2)
      + theme_few()
      + scale_color_manual(values=c("salmon"),
			   limits=c("Lung"))
      + ylab("Number of genes")
      + xlab("Number of samples")
      + theme(legend.title = element_blank())
      + theme(legend.text = element_text(size = 10))
      + theme(legend.position="none")
      +scale_x_continuous(breaks = c(0,100,200,300,400,500,600,700))
      +scale_y_continuous(breaks = c(0,1e+06,2e+06,3e+06,4e+06,5e+06,6e+06,7e+06))
      + theme(axis.title.y = element_text(size=12))
      + theme(axis.text.y = element_text(size=12,colour="black"))
      + theme(axis.title.x = element_text(size=12))
      + theme(axis.text.x = element_text(size=12,colour="black")))
ggsave("gene_accumulation.pdf" , plot = last_plot(),width = 5.5,height = 5)

###Figure 1B
library(data.table)			
data <- fread("counts_test.txt",head=T,check.names = F,sep = "\t")
Average <- data$Average*1000000
j=0
range <- rep(NA,51) 
counts <- rep(NA,51)			
for (i in 1:50){
	counts[i]<- length(Average[(Average>j) & (Average<= j+0.003)])
	range[i] <- paste(j,j+0.003,sep="~")
        j=j+0.003
}
counts[51] <- length(which(Average>0.15))
range[51] <- ">0.15"
table <- data.frame(cbind(range,counts))
table$group <- rep(NA,nrow(table))
mean <- mean(data$Average)
mean*1000000
#[1] 0.09968507
range[34]
#[1] "0.099~0.102"

table$group[1:33] <- "Low abundance"
table$group[34] <- "Average abundance"
table$group[35:51] <- "High abundance"

table$group <- factor(table$group,levels=c("Low abundance","Average abundance","High abundance"))
table$range <- factor(table$range,levels=table$range)
table$counts <- as.numeric(table$counts)/1000000
library(ggplot2)
ggplot(table,aes(x = range,y=counts,fill=group))+
	geom_bar(stat="identity")+
	labs(x="(Average relative abundance / 1,000,000) of genes in 744 samples",y="Gene numbers (×1,000,0000)") +
	theme_bw()+
	scale_fill_manual(values = c("#C8DAE9","#F8766D","#00BFC4"))+
	theme(panel.grid.major = element_line(colour = NA),
	panel.grid.minor = element_blank(),
	panel.background = element_rect(color = "black"),
	axis.title.y = element_text(size = 9,color="black"),
	axis.title.x = element_text(size = 9,color="black"),
	axis.text.y = element_text(size = 8,color="black"),
	axis.text.x = element_text(size = 6,color="black",angle = 90),
	legend.title = element_blank(),
	legend.text = element_text(size = 8),
	legend.position = c(0.8,0.86),
	legend.key.size = unit(10, "pt"))
ggsave("gene_range_number.pdf", width=4.5, height=4)

###Figure 1C
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

###Figure 1E
##taxa proportion
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

###Figure 1F
##Function proportion
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