library(ggplot2)
library(ggpubr)
vfdb <- read.table("vfg_anno_clust.tab",sep="\t", header=F)
ggplot(vfdb,aes(x=V3,y=V2,fill=V3))+geom_boxplot(outlier.size = 0,position = position_dodge(0.65),size=0.5,width=0.6)+  
	scale_fill_manual(breaks = c("Clade Ⅰ", "Clade Ⅱ"),values=c("#FFAE4C", "#4C924C"))+ 
	stat_compare_means(aes(group=V3),label ="p.format",label.y = 80,label.x=1.3)+theme_bw()+ 
	theme(panel.grid = element_blank(),legend.title=element_blank(), legend.position="none")+ 
	theme(legend.text = element_text(size = 12))+ theme(axis.title.y = element_text(size=12))+ 
	theme(axis.text.y = element_text(size=12,colour="black"))+theme(axis.title.x = element_text(size=14))+  
	theme(axis.text.x = element_text(size=12,colour="black"))+ylab("Number of virulence factor genes")+ xlab("")
ggsave("vfg_clade_compare.tiff", height=3.5, width=3.5,dpi=600)

eggnog <- read.table("eggnog_clust.tab",sep="\t", header=F)
ggplot(eggnog,aes(x=V3,y=V2,fill=V3))+geom_boxplot(outlier.size = 0,position = position_dodge(0.65),size=0.5,width=0.6)+  
	scale_fill_manual(breaks = c("Clade Ⅰ", "Clade Ⅱ"),values=c("#FFAE4C", "#4C924C"))+ 
	stat_compare_means(aes(group=V3),label ="p.format",label.y = 595,label.x=1.3)+theme_bw()+ 
	theme(panel.grid = element_blank(),legend.title=element_blank(), legend.position="none")+ 
	theme(legend.text = element_text(size = 12))+ theme(axis.title.y = element_text(size=12))+ 
	theme(axis.text.y = element_text(size=12,colour="black"))+theme(axis.title.x = element_text(size=14))+  
	theme(axis.text.x = element_text(size=12,colour="black"))+ylab("Number of eggNOG orthologs")+ xlab("")
ggsave("eggnog_clade_compare.tif", height=3.5, width=3.5,dpi=600)

KO <- read.table("KO_clust.tab",sep="\t", header=F)
ggplot(KO,aes(x=V3,y=V2,fill=V3))+geom_boxplot(outlier.size = 0,position = position_dodge(0.65),size=0.5,width=0.6)+  
	scale_fill_manual(breaks = c("Clade Ⅰ", "Clade Ⅱ"),values=c("#FFAE4C", "#4C924C"))+ 
	stat_compare_means(aes(group=V3),label ="p.format",label.y = 373,label.x=1.3)+theme_bw()+ 
	theme(panel.grid = element_blank(),legend.title=element_blank(), legend.position="none")+ 
	theme(legend.text = element_text(size = 12))+ theme(axis.title.y = element_text(size=12))+ 
	theme(axis.text.y = element_text(size=12,colour="black"))+theme(axis.title.x = element_text(size=14))+  
	theme(axis.text.x = element_text(size=12,colour="black"))+ylab("Number of KEGG orthologs")+ xlab("")
ggsave("KO_clade_compare.tiff", height=3.5, width=3.5,dpi=600)