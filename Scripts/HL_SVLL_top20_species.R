library(reshape2)
library(ggplot2)
spec_hl <- read.table("hl_core_species.tab" ,header=F,row.names=1, sep="\t")
spec_svll <- read.table("svll_core_species.tab" ,header=F,row.names=1, sep="\t")
###obtained top20 species in the HL
spec_hl_mean <- apply(spec_hl,1 , mean)
spec_hl_top20<- spec_hl[order(spec_hl_mean,decreasing = T)[1:20],]
spec_hl_top20_log <- log10(spec_hl_top20)
###obtained top20 species in the SVlL
spec_svll_mean <- apply(spec_svll,1 , mean)
spec_svll_top20<- spec_hl[order(spec_svll_mean,decreasing = T)[1:20],]
spec_svll_top20_log <- log10(spec_svll_top20)
###find unique species in the SVLL 
svll_uniq <- setdiff(rownames(spec_svll_top20),rownames(spec_hl_top20))		
rep <- rep(NA,ncol(spec_hl_top20))	
length(svll_uniq )
top20_hl_add <- rbind(spec_hl_top20_log, rep,rep)
rownames(top20_hl_add)[21:22] <- svll_uniq
top20_hl_add$spec_hlies <- rownames(top20_hl_add)
top20_hl_add.melt <- melt(top20_hl_add)
###core species in HL
ggplot(top20_hl_add.melt, aes(x=spec_hlies, y=value))+ 
	geom_boxplot(fill="#00BFC4", outlier.size=0.6)+coord_flip()+ 
	scale_x_discrete(limits=rev(levels(top20_hl_add.melt$spec_hlies)))+
	scale_y_continuous(breaks=c(-6,-5,-4,-3,-2))+labs(y="Relative abundance (log10)",x=NULL)+theme_bw()+   
	theme(panel.grid.major = element_blank(),
	      panel.grid.minor = element_blank(),
	      plot.title = element_text(hjust = 0.5),
	      xis.text.x = element_text(size = 9,color="black"), 
	      axis.text.y = element_text(size = 9,color="black"),
	      axis.title.x = element_text(size = 9,color="black"))
ggsave("hl_top20_combine.pdf",width=3.5,height=5)

###find unique species in the HL 
hl_uniq <- setdiff(rownames(spec_hl_top20),rownames(spec_svll_top20))
rep <- rep(NA,ncol(spec_svll_top20))
top20_svll_add <- rbind(spec_svll_top20_log, rep,rep)
rownames(top20_svll_add)[21:22] <- hl_uniq
top20_svll_add$spec_svllies <- rownames(top20_svll_add)
top20_svll_add.melt <- melt(top20_svll_add)

###core species in HL
ggplot(top20_svll_add.melt, aes(x=spec_hlies, y=value))+ 
	geom_boxplot(fill="#f8766d", outlier.size=0.6)+coord_flip()+ 
	scale_x_discrete(limits=rev(levels(top20_svll_add.melt$spec_hlies)))+
	scale_y_continuous(breaks=c(-6,-5,-4,-3,-2))+labs(y="Relative abundance (log10)",x=NULL)+theme_bw()+   
	theme(panel.grid.major = element_blank(),
	      panel.grid.minor = element_blank(),
	      plot.title = element_text(hjust = 0.5),
	      xis.text.x = element_text(size = 9,color="black"), 
	      axis.text.y = element_text(size = 9,color="black"),
	      axis.title.x = element_text(size = 9,color="black"))
ggsave("svll_top20_combine.pdf",width=3.5,height=5)
