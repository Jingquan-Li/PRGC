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