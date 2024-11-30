###Figure 6
###Figure 6B
C <- read.table("P46_IOD.txt",header = T,row.names=1)

C$Mean <- log10(C$Mean)
C$Group<-  factor(C$Group,level=c("NC","168L","LH"))
compare <- list(c("NC", "168L"),
    c("NC","LH"),
    c("168L","LH"))
	
library(ggplot2)
ggplot(C, aes(fill=Group, y=Mean, x=Group))+
geom_bar(position=position_dodge(1),stat="summary",width=0.7,colour = "black",size=0.2)+
theme_classic(base_size = 12)+
geom_bar(position=position_dodge(1),stat="summary",width=0.7,colour = "black",size=0.2)+
stat_summary(fun.data = 'mean_se', geom = "errorbar", colour = "black",
width = 0.2,position = position_dodge(1))+
theme(legend.direction = "horizontal", legend.position = "none")+
labs(title = "", y=" M.hyopneumoniae DNA copies (log10)", x = "")+
#scale_y_continuous(limits = c(0,6000),expand = c(0,0))+
theme(axis.text.x = element_text(size = 12,colour="black"))+
theme(axis.text.y = element_text(size = 12,colour="black"))+
theme(axis.title = element_text(size = 12))+
geom_jitter(data = C, aes(y = Mean),size = 3, shape = 21,
stroke = 0.01, show.legend = FALSE,
position = position_jitterdodge(jitter.height=0.01,dodge.width = 1))+
geom_signif(comparisons = compare,
step_increase = 0.3,
map_signif_level = F, #修改参数map_signif_level=TRUE
test = t.test)+
scale_fill_manual(values = c('grey','#e18283','#0d898a'))
ggsave("P46_IOD.pdf",width=3,height = 4)

###Figure 6C
B <- read.table("mhp_qPCR.txt",header = T,row.names=1)

B$Mean <- log10(B$Mean)
B$Group<-  factor(B$Group,level=c("NC","168L","LH"))
compare <- list(c("NC", "168L"),
    c("NC","LH"),
    c("168L","LH"))
	
library(ggplot2)
ggplot(B, aes(fill=Group, y=Mean, x=Group))+
geom_bar(position=position_dodge(1),stat="summary",width=0.7,colour = "black",size=0.2)+
theme_classic(base_size = 12)+
geom_bar(position=position_dodge(1),stat="summary",width=0.7,colour = "black",size=0.2)+
stat_summary(fun.data = 'mean_se', geom = "errorbar", colour = "black",
width = 0.2,position = position_dodge(1))+
theme(legend.direction = "horizontal", legend.position = "none")+
labs(title = "", y=" M.hyopneumoniae DNA copies (log10)", x = "")+
#scale_y_continuous(limits = c(0,6000),expand = c(0,0))+
theme(axis.text.x = element_text(size = 12,colour="black"))+
theme(axis.text.y = element_text(size = 12,colour="black"))+
theme(axis.title = element_text(size = 12))+
geom_jitter(data = B, aes(y = Mean),size = 3, shape = 21,
stroke = 0.01, show.legend = FALSE,
position = position_jitterdodge(jitter.height=0.01,dodge.width = 1))+
geom_signif(comparisons = compare,
step_increase = 0.3,
map_signif_level = F, #修改参数map_signif_level=TRUE
test = t.test)+
scale_fill_manual(values = c('grey','#e18283','#0d898a'))

ggsave("Mhp_qPCR.pdf",width=3,height = 4)

###Figure 6E
A <- read.table("TEER.txt",sep="\t",header = T,row.names = 1)
A$Group<- as.factor(A$Group)
library(ggplot2)
A$Group<- as.factor(A$Group,levels=c("NC","168L","LH"))
library(ggsignif)
compare <- list(c("NC", "168L"),
    c("NC","LH"),
    c("168L","LH"))

ggplot(A, aes(fill=Group, y=TEER, x=Group))+
geom_bar(position=position_dodge(1),stat="summary",width=0.7,colour = "black",size=0.2)+
theme_classic(base_size = 12)+
geom_bar(position=position_dodge(1),stat="summary",width=0.7,colour = "black",size=0.2)+
stat_summary(fun.data = 'mean_se', geom = "errorbar", colour = "black",
width = 0.2,position = position_dodge(1))+
theme(legend.direction = "horizontal", legend.position = "none")+
labs(title = "", y="TEER (Ω)", x = "")+
#scale_y_continuous(limits = c(0,6000),expand = c(0,0))+
theme(axis.text.x = element_text(size = 12,colour="black"))+
theme(axis.text.y = element_text(size = 12,colour="black"))+
theme(axis.title = element_text(size = 12))+
geom_jitter(data = A, aes(y = TEER),size = 3, shape = 21,
stroke = 0.01, show.legend = FALSE,
position = position_jitterdodge(jitter.height=1,dodge.width = 1))+
geom_signif(comparisons = compare,
step_increase = 0.3,
map_signif_level = F, #修改参数map_signif_level=TRUE
test = t.test)+   ##wilcox.test
scale_fill_manual(values = c('grey','#e18283','#0d898a'))
ggsave("TEER.pdf",width=2.9,height = 4)

###Figure 6F
data <- read.table("enrich_pathway_expr_fpkm.tab",header=T,sep="\t",check.names=F)
data2 <- data[,-c(1,7:9,14)]
data3 <- apply(data2, 1, scale)
data3 <-t(data3)
head(data3)
library(circlize)
col_fun <- colorRamp2(
   c(-2, 0, 2), 
   c("#4575B4", "white", "#D73027"))
 group <- c(rep("168L-Infect",5),rep("LH-Infect",4),rep("Uninfect",4))
 group <- data.frame(group)
library(tidyverse)
data3 <- data.frame(data3)
names(data3)  <- names(data2)
group2 <- group[,1]> group$ID  <- names(data2)
group2 <- group[,1]
group$ID  <- names(data2)
head(group)
group$group <- factor(group$group, levels=c("Uninfect","168L-Infect","LH-Infect"))
col_order  <- order(group[,1])
col_names  <- group[col_order,]$ID
Group <- group[,1]
Group <- sort(group[,1])
Group <- data.frame(Group)
Group$Group <- factor(Group$Group , levels=c("Uninfect","168L-Infect","LH-Infect"))
library(ComplexHeatmap)
mean_168l  <- apply(data[1:5,],1,mean)
mhp_168l <- data[1:5,]
rownames(data3) <- data$ID
mean_168l  <- apply(data3[,1:5],1,mean)
data3_order <- data3[order(mean_168l,decreasing = F),]
head(data3_order)
topanno=HeatmapAnnotation(df=Group,border = T, show_annotation_name = F, col = list(Group=c('Uninfect'='grey', '168L-Infect'='#0d898a', 'LH-Infect'='#e18283')))
gene <- data$ID
labs <- gene
genemark <- which(rownames(data3) %in% gene)
#gene_anno <-  rowAnnotation(foo = anno_mark(at = genemark, labels = labs, labels_gp = gpar(fontsize = 7)))
genemark <- which(rownames(data3_order) %in% gene)
gene_anno <-  rowAnnotation(foo = anno_mark(at = genemark, labels = labs, labels_gp = gpar(fontsize = 7)))

gene <- rownames(data3_order)
labs <- gene
genemark <- which(rownames(data3_order) %in% gene)
gene_anno <-  rowAnnotation(foo = anno_mark(at = genemark, labels = labs, labels_gp = gpar(fontsize = 6.6)))

gene1 <- head(rownames(data3_order),35)

labs1 <- gene1
genemark1 <- which(rownames(data3_order) %in% gene1)

gene2  <- tail(rownames(data3_order),35)
head(gene2)
length(gene2)
labs2 <- gene2
genemark2 <- which(rownames(data3_order) %in% gene2)

gene_anno1 <-  rowAnnotation(foo = anno_mark(at = genemark1, labels = labs1, labels_gp = gpar(fontsize = 7)))
gene_anno2  <-  rowAnnotation(foo = anno_mark(at = genemark2, labels = labs2, labels_gp = gpar(fontsize = 7)))
pdf("complexheatmap.pdf",width=5.5,height=8)
Heatmap(data3_order[,col_names], name="Expression",col=col_fun, cluster_columns = F,show_column_names = F, show_row_names = F, \ 
	top_annotation = topanno, border = F, left_annotation=gene_anno1, right_annotation=gene_anno2, \ 
	cluster_rows = F, border_gp = gpar(lwd = 2), column_split = Group, column_gap = unit(2, "mm"))
dev.off()