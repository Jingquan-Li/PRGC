
library(reshape2)
####Fungi
fungi <- read.table("Fungi_mean_phy2spec.tab",header=F,sep="\t",quote="")
fungi$V3<- fungi$V3/sum(fungi$V3)*100
names(fungi)  <- c("Phylum","Species","Abundance")

library(RColorBrewer)
col2 <- colorRampPalette(c('#EAF0E6','#2D3C22'))(14)
#colors2 <- c(col2, "#F7E8EC","#D89AAB","#D89AAB","#CE8498","#C56B84","#BA506D","#B76CDB","#F2EA9B")
colors2 <- c(col2[1:6],"#B3CAA4", "#A7C195", "#94B57D","#7CA561",col2[10:13],"#F7E8EC","#D89AAB","#D89AAB","#CE8498","#C56B84","#BA506D","#B76CDB","#F2EA9B")
fungi_melt <- melt(fungi)
fungi_melt_order <- fungi_melt[order(fungi_melt$Phylum,fungi_melt$value),]
fungi_melt_order$Species <- factor(fungi_melt_order$Species ,levels=fungi_melt_order$Species )
fungi_melt_order$variable <- "Fungi"
ggplot(fungi_melt_order,aes(x=variable,y=value,fill=Species))+geom_bar(stat = "identity",width = 0.3)+
theme_classic()+theme(axis.text.x = element_text(angle = 30,hjust=1,size = 10,color="black"),
panel.grid = element_blank(),axis.text.y = element_text(color="black"),axis.title.x = element_blank(),
axis.text = element_text(size = 10),axis.title.y = element_text(size=12))+ylab("Relative abundance")+
scale_fill_manual(values = colors2)
ggsave("fungi_relative.pdf",width = 6,height = 3.5)


###########Virus
virus <- read.table("Virus_mean_phy2spec.tab",header=F,sep="\t",quote="")
virus$V3<- virus$V3/sum(virus$V3)*100
names(virus)  <- c("Phylum","Species","Abundance")
virus_melt <- melt(virus)
virus_melt_order <- virus_melt[order(virus_melt$Phylum,virus_melt$value),]
virus_melt_order <- virus_melt[order(virus_melt$Phylum,virus_melt$value),]
virus_melt_order$Species <- factor(virus_melt_order$Species ,levels=virus_melt_order$Species )
###colors
yellow <- colorRampPalette(c('#EEE8AC','#DAC71B'))(5)
green <- c(col2[c(1,3,5)],"#B3CAA4",  "#94B57D","#7CA561",col2[c(10,13)])
"#17C7CB","#13A5A9","#B4533C","#003A6C","#3FDA6D","#22B34E",
purple <- colorRampPalette(c('#A8A0C3','#68228B'))(5)
blue <- colorRampPalette(c('#DAE3EB','#2E4556'))(4)
lighltblue<- colorRampPalette(c('#E8F2FE','#0A509E))(6)
red<- colorRampPalette(c('#F7E8EC','#933952'))(8)
colors3 <- c(yellow,green,"#17C7CB","#13A5A9","#B4533C","#003A6C","#3FDA6D","#22B34E",purple,blue , lighltblue,red)
ggplot(virus_melt_order,aes(x=variable,y=value,fill=Species))+geom_bar(stat = "identity",width = 0.3)+
theme_classic()+theme(axis.text.x = element_text(size = 10,color="black"),panel.grid = element_blank(),
axis.text.y = element_text(color="black"),axis.title.x = element_blank(),axis.text = element_text(size = 10),
axis.title.y = element_text(size=12))+ylab("Relative abundance")+scale_fill_manual(values = colors3)
ggsave("virus_relative.pdf",width = 9,height = 3.5)





setwd("C:\\Users\\Lee\\Desktop\\lijingquan\\F7_meta\\R\\Virus_fungi_archaea")
domain <- read.table("Kingdom_relative.tab",header = F,sep="\t",quote="",row.names=1)
domain$V2 <- domain$V2/sum(domain$V2)*100
 color <- c("#799F5F","#BC687F","#D5C743","#356AA5")
domain$kingdom <- rownames(domain)
library(ggplot2)
ggplot(domain_melt,aes(x=variable,y=value,fill=kingdom))+geom_bar(stat = "identity",width = 0.3)+
theme_classic()+
theme(axis.text.x = element_text(size = 10,color="black"),panel.grid = element_blank(),
axis.text.y = element_text(color="black"),axis.title.x = element_blank(),axis.text = element_text(size = 10),
axis.title.y = element_text(size=12))+ylab("Relative abundance")+scale_fill_manual(values = color)

ggsave("Kingdom_relative.pdf",width = 2.7,height = 3.5)
