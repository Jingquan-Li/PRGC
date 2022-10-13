#!/usr/bin/env  Rscript
library(data.table)
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(grid)
library(stats)
library(ggthemes) 
pre <- read.table("gene_bwa_relative.txt", row.names = 1,header = T, check.names = F,quote="",stringsAsFactors=FALSE)
###convert gene abundance to 0 or 1
pre <- (pre[,1:ncol(pre)] !=0)*1


subsampling = seq(1,ncol(bact), 10)
dset.subsamp = data.frame(matrix(0,length(subsampling),4))
#####sample from 1 to ncol(bact) 
reps = 10
for (i in 1:length(subsampling)){
	    rep = c(rep(0,reps))
    for (n in 1:reps){
	            cols = sample(colnames(bact),subsampling[i])
            if (length(cols)<=1){rep[n] = length(which(bact[,cols] > 0))}
	            else  {rep[n] = length(which(rowSums(bact[,cols]) > 0))}
    }
        dset.subsamp[i,1] = subsampling[i]
        dset.subsamp[i,2] = mean(rep)
	    dset.subsamp[i,3] = sd(rep)
}
colnames(dset.subsamp) = c("Samples", "Species", "SD", "Origin")
dset.subsamp$Origin = "Lung"
print(ggplot(dset.subsamp, aes(x=Samples, y=Species, colour=Origin))
      + geom_smooth(method="nls", formula=y~SSasymp(x, Asym, R0, lrc), se=F, size=0.35)
      + geom_point(size=0.2)
      + theme_few()
      + scale_color_manual(values=c("salmon"),
			   limits=c("Lung"))
      + ylab("Number of genes")
      + xlab("Number of samples")
      + theme(legend.title = element_blank())
      + theme(legend.text = element_text(size = 10))
      + theme(legend.position="none")
      +scale_x_continuous(breaks = c(0,100,200,300,400,500,600,700))
      +scale_y_continuous(breaks = c(0,1e+06,2e+06,3e+06,4e+06,5e+06,6e+06,7e+06))
      + theme(axis.title.y = element_text(size=14))
      + theme(axis.text.y = element_text(size=12,colour="black"))
      + theme(axis.title.x = element_text(size=14))
      + theme(axis.text.x = element_text(size=12,colour="black")))
ggsave("gene_accumulation.pdf" , plot = last_plot(),width = 5.5,height = 5)
