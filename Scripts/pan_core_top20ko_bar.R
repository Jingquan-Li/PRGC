library(ggplot2)
###core 
core_ko <- read.table("core_top20_ko.anno.tab",sep="\t")
CPCOLS <-  c("#8DA1CB", "#FD8D62", "#66C3A5","#AAD7ED", "#EAAC5D","grey")

level1<-as.factor(core_ko$V1)
p <- ggplot(ko, aes(x=reorder(core_ko$V2,X=as.numeric(core_ko$V3),decreacing=F), as.numeric(core_ko$V3),fill=level1))+ 
	geom_bar(stat="identity", width=0.8)+coord_flip() + scale_fill_manual(values = CPCOLS) +
	theme_test() + xlab("KEGG pathways")+ ylab("Number of genes")+ 
	theme(axis.text=element_text( color="black"))
ggsave("core_top20ko.pdf",width=7,height=3)

###pan
pan_ko <- read.table("pan_top20_ko.anno.tab",sep="\t")
CPCOLS <-  c("#8DA1CB", "#FD8D62", "#66C3A5","#AAD7ED", "#EAAC5D","grey")
level1<-as.factor(pan_ko$V1)
p <- ggplot(ko, aes(x=reorder(pan_ko$V2,X=as.numeric(pan_ko$V3),decreacing=F), as.numeric(pan_ko$V3),fill=level1))+ 
	geom_bar(stat="identity", width=0.8)+coord_flip() + scale_fill_manual(values = CPCOLS) +
	theme_test() + xlab("KEGG pathways")+ ylab("Number of genes")+ 
	theme(axis.text=element_text( color="black"))
ggsave("pan_top20ko.pdf",width=7,height=3)