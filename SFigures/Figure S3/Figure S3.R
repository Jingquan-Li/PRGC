library(ggplot2)
library(ggrastr)
library(reshape2)
library(gridExtra)
dset <- read.delim("checkm_50_10.stats",row.names = 1)

dset$QS = dset$completeness-(5*dset$contamination)
dset$lineage = rep(0,nrow(dset))
dset$lineage[which(dset$completeness >= 50 & dset$contamination  < 10 & dset$QS<= 50)] = "Medium quality (QS <= 50)"
dset$lineage[which(dset$QS> 50)] = "Medium quality (QS > 50)"
dset$lineage[which(dset$completeness > 90 & dset$contamination  < 5)] = "Near complete"

p1 <- print(ggplot(dset, aes(x=completeness, y=contamination, colour=lineage))
	+ geom_point_rast(size=1.2, alpha=0.8)
	+ scale_color_manual(name="",limits=c( "Medium quality (QS <= 50)",
	"Medium quality (QS > 50)", "Near complete"),
	values=c( "steelblue", "#000033", "darkolivegreen3"))
	+ guides(colour = guide_legend(override.aes = list(size=5, alpha=0.8)))
	+ theme_bw()
	+ ylab("Contamination (%)")
	+ xlab("Completeness (%)")
	+ ylim(0,7)
	+ theme(axis.title.y = element_text(size=12))
	+ theme(axis.text.y = element_text(size=12,colour = "black"))
	+ theme(axis.title.x = element_text(size=12))
	+ theme(axis.text.x = element_text(size=12,colour = "black"),legend.position = "bottom"))

med = length(which(dset$lineage=="Medium quality (QS <= 50)"))
med_qs50 = length(which(dset$lineage == "Medium quality (QS > 50)"))
med_near = length(which(dset$lineage == "Near complete"))
df_qual = data.frame(matrix(c(med,med_qs50,med_near),1))

colnames(df_qual) = c( "Medium quality (QS <= 50)", "Medium quality (QS > 50)",
"Near complete")
df_stack = melt(df_qual)
head(df_qual)
df_stack$quality = factor(c( "Medium", "Medium", "High"))

p2 <- print(ggplot(df_stack, aes(x=quality, y=as.numeric(as.character(value)), fill=variable))
	+ geom_bar(stat="identity", width = 0.6, alpha=0.6)
	+ theme_bw()
	+ scale_fill_manual(name="",
	limits=c( "Medium quality (QS <= 50)","Medium quality (QS > 50)", "Near complete"),
	values=c( "steelblue", "#000033", "darkgreen"))
	+ scale_x_discrete(limits=c("Medium", "High"),
	labels=c("> 50% complet.\n< 10% cont.","> 90% complet.\n< 5% cont."))
	+ ylab("Number of MAGs")
	+ theme(axis.title.y = element_text(size=12))
	+ theme(axis.text.y = element_text(size=12,colour = "black"))
	+ theme(axis.title.x = element_blank())
	+ theme(axis.text.x = element_text(size=12,colour = "black"),legend.position = "bottom"))
grid.arrange(p1,p2, ncol = 2)
ggsave("MAGs_quality.pdf", width = 9,height = 4)