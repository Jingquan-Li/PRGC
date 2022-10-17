taxa <- read.table("taxa_abundance_f7.tab" ,header=T,row.names=1,sep="\t",check.names=F )
meta <- read.csv("Lung_site_group.csv",check.names = F)
F7_Lung <- meta[which(F7_Lung$Site=="Lung" & F7_Lung$Population=="F7"),]
F7_Lung$Grade <- factor(F7_Lung$Grade,levels = c("HL","SLL","MLL","SVLL"))
library(vegan)
taxa <- t(taxa)
shannon <- diversity(taxa, index = "shannon", MARGIN = 1, base = exp(1))
specnumber <- specnumber(taxa,MARGIN=1)

group <- F7_Lung$Population
sample_id <- rownames(taxa)
data_group <- data.frame(sample_id, group)
shannon <- data.frame(shannon_NR_genus)
shannon_group<- data.frame(shannon,specnumber,group)
head(shannon_group)
group <- F7_Lung$Grade
data_group <- data.frame(sample_id, group)
alpha_group<- data.frame(shannon,specnumber,group)
library(ggpubr)
my_comparisons <- list(c("HL","SLL"),c("SLL","MLL"),c("MLL","SVLL"),
c("HL","MLL"),c("SLL","SVLL"), c("HL","SVLL"))
names(alpha_group) <- c("Shannon","Richness","Grade")
head(alpha_group)
label <- c("HL\n(n=51)","SLL\n(n=217)","MLL\n(n=218)","SVLL\n(n=127)")

richness_compare <- compare_means(Richness~Grade, data=alpha_group,p.adjust.method = "fdr")
shannon_compare <- compare_means(Shannon~Grade, data=alpha_group,p.adjust.method = "fdr")
shannon_compare
richness_compare
pdf("F7_Lung_richness.pdf",width = 2200,height = 2300,compression="lzw")

ggboxplot(alpha_group, x="Grade", y="Richness",  color  = "Grade", add = "jitter",
	palette = c("#008B8B","#FFA500","#FB8072","#BEBEBE")) +
	guides(fill="none")+
	border("grey")+
	labs(y="Observed Species",x=NULL)+
	scale_x_discrete("Grade",labels = label)+
	theme(axis.title.x = element_blank(),
	legend.position = "none")+
	stat_compare_means(comparisons = list(my_comparisons[[3]],
	my_comparisons[[5]], my_comparisons[[6]]),
	label = "p.format",tip.length = 0)
dev.off()

pdf(filename = "F7_Lung.Shannon.pdf",width = 2200,height = 2300,compression="lzw")

ggboxplot(alpha_group, x="Grade", y="Shannon",  color  = "Grade", add = "jitter",
	palette = c("#008B8B","#FFA500","#FB8072","#BEBEBE")) +
	guides(fill="none")+
	labs(y="Shannon index",x=NULL)+
	border("grey")+
	scale_x_discrete("Grade",labels = label)+
	theme(axis.title.x = element_blank(),
	legend.position = "none")+
	stat_compare_means(comparisons = list(my_comparisons[[2]]),my_comparisons[[3]],
	my_comparisons[[4]],my_comparisons[[5]], my_comparisons[[6]],
label = "p.signif",tip.length = 0)
dev.off()



###beta diversity
taxa <- as.data.frame(taxa)

taxa$Sample <- F7_Lung$Grade

HL <- data[which(data$Sample == "HL"),]
HL <- taxa[which(taxa$Sample == "HL"),]
head(HL)
HL <- taxa[which(taxa$Sample == "HL"),-1612]
head(HL)
SLL <- taxa[which(taxa$Sample == "SLL"),-1612]
MLL <- taxa[which(taxa$Sample == "MLL"),-1612]
SVLL <- taxa[which(taxa$Sample == "SVLL"),-1612]
HL_distance <- vegdist(HL,method="bray") #bray distance matrix
SLL_distance <- vegdist(SLL,method="bray")
MLL_distance <- vegdist(MLL,method="bray")
SVLL_distance <- vegdist(SVLL,method="bray")
distance <- c(HL_distance,SLL_distance,MLL_distance,SVLL_distance)
dim(HL_distance)
dim(HL)
51*50/2
dim(SLL)
217*216/2
Grade <- rep(c("HL","SLL","MLL","SVLL"),c(1275,23436,23653,8001))
distance.data <- data.frame(Grade,distance)
compare_means(distance~Grade, data=distance.data,p.adjust.method = "fdr")
pdf(filename = "Beta_F7_Lung.pdf",width = 2200,height = 2300,compression="lzw")

ggviolin(distance.data, x="Grade", y="distance",  fill  = "Grade", add = "boxplot",
	palette = c("#008B8B","#FFA500","#FB8072","#BEBEBE")) +
	guides(fill="none")+
	labs(y="Beta Diversity",x=NULL)+
	border("grey")+
	scale_x_discrete("Grade",labels = label)+
	theme(axis.title.x = element_blank(),
	legend.position = "none")+
	stat_compare_means(comparisons = list(my_comparisons[[2]],
	my_comparisons[[4]],
	my_comparisons[[5]],
	my_comparisons[[6]]),
	label = "p.format",
	tip.length = 0)
dev.off()