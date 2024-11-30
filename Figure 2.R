###Figure 2
###Figure 2A
library(reshape2)
library(pheatmap)
library(ggplot2)
library(RColorBrewer)
library(gdata)
library(Rmisc)
dset = read.table("taxacounts.tab", sep="\t")
head(dset)
colnames(dset) = c("Rank", "Taxon", "Counts")
#dset$Percentage = dset$Counts/dset[dset$Rank=="Kingdom","Counts"]*100

dset$Percentage = dset$Counts/sum(dset[dset$Rank=="Kingdom",]$Counts)*100
sum(dset$Percentage)
rank_order = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
dset$Rank = reorder.factor(dset$Rank, new.order=rank_order)

class(dset$Rank)
dset = dset[order(dset$Rank,dset$Counts),]
head(dset)
dset$Taxon = factor(dset$Taxon, levels=dset$Taxon)
ranks_selected = c("Phylum", "Class", "Order", "Family", "Genus","Species")
ranks_selected
rm(new.dset)
###select top5 taxa, remains classified as others
for (r in 1:length(ranks_selected)){
prefix = tolower(substr(ranks_selected[r], 1, 1))
dset.rank = dset[dset$Rank == ranks_selected[r],]
dset.rank.others = dset.rank[1:(nrow(dset.rank)-5),]
dset.newrow = data.frame(Rank=ranks_selected[r], Taxon=paste(prefix,"__Other", sep=""), Counts=sum(dset.rank.others$Counts),
Percentage=sum(dset.rank.others$Percentage), Colour="grey")
dset.rank.top = dset.rank[(nrow(dset.rank)-4):nrow(dset.rank),]
dset.toprow = data.frame(Rank=ranks_selected[r], Taxon=dset.rank.top$Taxon, Counts=dset.rank.top$Counts,
Percentage=dset.rank.top$Percentage, Colour=rev(brewer.pal(5,"Set1")))
if (!exists("new.dset")) {
new.dset = rbind(dset.newrow, dset.toprow)
} else {
new.dset = rbind(new.dset, dset.newrow, dset.toprow)
}
}
new.dset$Taxon = factor(new.dset$Taxon, levels=new.dset$Taxon)
print(dset[which(dset$Rank == "Phylum"),])

print(ggplot(new.dset, aes(x=Rank, y=Percentage, fill=Taxon))
+ geom_bar(stat="identity", colour="black", alpha=0.5, size=0.2)
+ theme_bw()
+ ylab("Proportion (%)")
+ scale_fill_manual(values=as.vector(new.dset$Colour))
+ scale_x_discrete(limits=ranks_selected)
+ ylim(0,100)
+ theme(axis.title.y = element_text(size=18))
+ theme(axis.text.y = element_text(size=15))
+ theme(axis.title.x = element_blank())
+ theme(axis.text.x = element_text(size=15, angle=90, hjust=1, vjust=0.3)))
ggsave("MAG_taxacounts.pdf" , plot = last_plot(),width = 7,height = 6)

##Figure 2B
library(ggplot2)
library(reshape2)
library(gridExtra)
data <- read.table("Phylum_sgb_stat.tab",header = T,check.names = F,sep = "\t")
uSGB_percent <- round(data$uSGB*100/data$SGB,digits = 0)
data$uSGB_percent <- uSGB_percent
SGB.data.melt <- melt(data[,2:6],id.vars = "Phylum")
SGB.data.melt$Phylum <- factor(SGB.data.melt$Phylum,levels = data$Phylum)
color2 <- c("#EA9527","#5ED2BF","#AAD7ED", "#EAAC5D", "#FFD0B0", "#3370D8", "#CAF5CE", "#CFCD3E", "#BCBCBC", "#946F35",  "#93c47d","#37AB5B", 
"#B07AAD", "#8C384F", "#DEB99B", "#F16E1D", "#DA5A5A", "#F96C72")

p1 <- ggplot(SGB.data.melt[which(SGB.data.melt$variable=="uSGB_percent"),],aes(x=Phylum,y=value,fill=Phylum))+
  geom_bar(stat = "identity")+scale_fill_manual(values = color2)+
  labs(x = NULL, y="Percent of uSGB") +
  theme_bw()+
  geom_text(aes(label=paste0(value,"%"),y=value+4),position=position_stack(vjust=1),size=2.5)+
  theme(panel.grid.major =element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        #axis.text.x = element_text(angle = 52, hjust = 1), 
        #axis.text.x = element_text(colour="black",angle = 90, hjust = 0,vjust = 1),
	axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        legend.title = element_blank(),
	axis.title.y = element_text(size = 10,color="black"),
        legend.position = "none")

p2 <- ggplot(SGB.data.melt[which(SGB.data.melt$variable=="SGB"),],aes(x=Phylum,y=value,fill=Phylum))+
  geom_bar(stat = "identity")+ scale_fill_manual(values = color2)+ 
  labs(x = NULL, y = "Number of SGB") +
  theme_bw()+
  geom_text(aes(label=value,y=value+3),position=position_stack(vjust=1),size=3)+
  theme(panel.grid.major =element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(colour="black",angle = 90, hjust = 0,vjust = 1), 
        #axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
	axis.title.y = element_text(size = 10,color="black"),
        legend.title = element_blank(),
        legend.position = "none")
grid.arrange(p1,p2, nrow = 2)
ggsave("Phylum_sgb.pdf", width=5,height=6)
