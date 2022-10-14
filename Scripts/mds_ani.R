ani <-read.csv("fastani_285.out.csv" ,header=T,row.names=1,check.names=F,quote="")
ani_dis <- as.dist(ani)
ani_dis_diss <- (100-ani_dis)
library(vegan)
mds<- cmdscale(ani_dis_diss, k = 284, eig = TRUE)

sample_site <- data.frame({mds$point})[1:2]
sample_site$sample_id <- rownames(sample_site)
names(sample_site)[1:2] <- c('MDS1', 'MDS2')

color <- c("#68C312", "#F7746E","#00BEC3","#C47AFF","#4C81DD","#AAD7ED","#B1DD8B","#946F35", "#CFCD3E")

data_group <- read.table("level_public.txt", sep="\t")
names(data_group) <-c("sample_id","Sub-clades", "Origin")
sample_site <- merge(sample_site, data_group, by = 'sample_id', all.x = TRUE)
library(ggplot2)
ggplot(sample_site, aes(MDS1, MDS2,color=`Sub-clades`,shape=Origin))+ 
	geom_point( size = 1.5)+labs(x = 'MDS1', y = 'MDS2')+
	scale_color_manual(values=color)+
	theme(axis.text.y = element_text(size=12,colour="black"))+  
	theme(axis.text.x = element_text(size=12,colour="black"))
ggsave("MDS_ani.pdf", width=4.5, height=3.5)
