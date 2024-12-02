###Figure S13A
df<- read.table("Child_phylum_relative.tab",header T,row.names =1,sep="\t",quote="",check.names=F)
df2 <- df[order(rowSums(df), decreasing=TRUE), ]
df2_sum <- as.list(t(apply(df2,2,sum)))
df3<- df2[1:10,]/df2_sum
df4 <- 1-apply(df3, 2, sum)
df5 <- rbind(df3,df4)
rownames(df5)[11] <- "Others"
df5$Taxonomy <- factor(rownames(df5), levels = rev(rownames(df5)))
library(reshape2)
df5_melt <- melt(df5, id = 'Taxonomy')
library(wesanderson)
library(RColorBrewer)
library(ggpubr)
df5_melt_100 <- df5_melt
df5_melt_100$Abundance <- df5_melt_100$value*100
df5_melt_100$type <- "Human (n = 46)"
###### plot human phylum
#ggbarplot(df5_melt_100, x = "variable", y="Abundance", fill="Taxonomy",legend="right",font.main = c( "black"))+theme_bw()+ scale_fill_manual(values=c("gray",brewer.pal(5,"Dark2"),brewer.pal(5,"Accent")))+facet_grid(~ type, scales = "free_x", space='free') +theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),panel.grid = element_blank(),axis.text.y=element_text(color="black",size=12),axis.title.y=element_text(size=12))+scale_y_continuous(expand = c(0,0))+labs(x="",y="Relative abundance")
#ggsave(filename = "phylumtop10_relative.pdf", device="pdf", width=6, height=6)

###Pig phylum
phy<- read.table("Pig_phylum_relative.tab",header=T,row.names =1,sep="\t",quote="",check.names=F)
phy2 <- df[order(rowSums(df), decreasing=TRUE), ]
phy2_sum <- as.list(t(apply(phy2,2,sum)))
phy3<- phy2[1:10,]/phy2_sum
phy4 <- 1-apply(phy3, 2, sum)
phy5 <- rbind(phy3,phy4)
rownames(phy5)[11] <- "Others"
phy5$Taxonomy <- factor(rownames(phy5), levels = rev(rownames(phy5)))
phy5_melt <- melt(phy5, id = 'Taxonomy')

phy5_melt_100 <- phy5_melt
phy5_melt_100$Abundance <- phy5_melt_100$value*100
phy5_melt_100$type <- "Pig (n = 670)"
###combine
human_pig <- rbind(df5_melt_100, phy5_melt_100)

human_pig$Taxonomy <-  factor(human_pig$Taxonomy,levels=c("Actinobacteria", "Ascomycota", "Bacteroidota" ,"Cossaviricota", "Cyanobacteria", "Deinococcus-Thermus","Euryarchaeota","Firmicutes", "Fusobacteria" ,"Nematoda","Preplasmiviricota", "Proteobacteria","Spirochaetes", "Tenericutes" , "Uroviricota","Others"))
names(human_pig)[1] <- "Phylum"
ggbarplot(human_pig, x = "variable", y="Abundance", size=0.2,color="Phylum",fill="Phylum",legend="right",
	font.main = c( "black"))+theme_bw()+ 
	scale_color_manual(values=c(colorRampPalette(brewer.pal(8,'Accent'))(16)[1:11],"#56A0CC",brewer.pal(8,'Dark2')[1:3],"gray"))+
	scale_fill_manual(values=c(colorRampPalette(brewer.pal(8,'Accent'))(16)[1:11],"#56A0CC",brewer.pal(8,'Dark2')[1:3],"gray"))+
	facet_grid(~ type, scales = "free_x", space='free') +
	theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),panel.grid = element_blank(),
	axis.text.y=element_text(color="black",size=11),axis.title.y=element_text(size=11),legend.text=element_text(size=11))+
	scale_y_continuous(expand = c(0,0))+labs(x="",y="Relative abundance")
ggsave("human_pig_top10.pdf",width=9,height=8)
