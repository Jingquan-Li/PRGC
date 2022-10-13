library(data.table)			
data <- fread("counts.txt",head=T,check.names = F,sep = "\t")			
for (i in 1:50){
	counts[i]<- length(Average[(Average>j) & (Average<= j+0.003)])
	range[i] <- paste(j,j+0.003,sep="~")
        j=j+0.003
}

ggplot(table,aes(x = range,y=counts,fill=group))+
	geom_bar(stat="identity")+
	labs(x="(Average relative abundance / 1,000,000) of genes in 745 samples",y="Gene numbers (×1,000,0000)") +
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
ggsave("gene_range_number.pdf", width=6, height=4)
