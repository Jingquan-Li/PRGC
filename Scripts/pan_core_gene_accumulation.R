################pan gene compare to public
library(ggplot2)
gene <- read.table("gene_presence_absence.Rtab",header=T,sep="\t", row.names=1,check.names=F)
meta <- read.table("genome_group.txt",header=T,sep="\t")
names(meta)<- c("Genome","origin")
rownames(meta) <- meta$Genome

mag <-rownames( meta[which(meta$origin=="MAGs"),])
pub <- rownames(meta[which(meta$origin=="Public"),])

groups <- c("MAGs", "Public")

for (c in groups) {
	samp.conds = rownames(meta)[which(meta$origin == c)]
	samp.cond.analys= gene[,samp.conds]
	subsampling = seq(1,ncol(samp.cond.analys),1)
	dset.subsamp = data.frame(matrix(0,length(subsampling),4))
	dset.subsamp.core <- dset.subsamp
	colnames(dset.subsamp) = c("Samples", "Species", "SD", "Origin")
	colnames(dset.subsamp.core) = c("Samples", "Species", "SD", "Origin")
	dset.subsamp$Origin = c
	reps = 999
	for (i in 1:length(subsampling)){
		rep = c(rep(0,reps))
		rep_core <- rep
		for (n in 1:reps){
			cols = sample(colnames(samp.cond.analys),subsampling[i])
			if (length(cols)==1){
				rep[n]=length(which(samp.cond.analys[,cols] > 0))
				rep_core[n]=rep[n]}
			else {
				rep[n] = length(which(rowSums(samp.cond.analys[,cols]) > 0))
				rep_core[n] = length(which(rowSums(samp.cond.analys[,cols]) > 0.95*(length(cols))))}
		}
		dset.subsamp[i,1] = subsampling[i]
		dset.subsamp[i,2] = mean(rep)
		dset.subsamp[i,3] = sd(rep)
		dset.subsamp.core[i,1] = subsampling[i]
		dset.subsamp.core[i,2] = mean(rep_core)
		dset.subsamp.core[i,3] = sd(rep_core)
	}
	if (c == "MAGs") { 
		dset.mag = dset.subsamp 
	        core.mag = dset.subsamp.core}
	else if (c == "Public") { 
		dset.pub = dset.subsamp
		core.pub = dset.subsamp.core}
}

core.mag$Origin="MAGs"
core.pub$Origin="Public" 

dset.mag$key="Pan genes"
dset.pub$key="Pan genes"
core.mag$key="Core genes"
core.pub$key="Core genes"
 
dset.line = rbind(dset.mag, dset.pub, core.mag, core.pub)

ggplot(data = dset.line, aes(x = Samples, y = Species/1000, color = Origin, linetype=key))+
	geom_line()+theme_bw()+  
	theme(panel.grid = element_blank(),legend.title=element_blank(),
	legend.margin=margin(b = -0.1, unit='cm'),
	legend.position=c(0.23,0.82),legend.key.height=unit(0.36, "cm"),
	legend.text=element_text(size=12))+
	theme(legend.text = element_text(size = 12))+
	theme(axis.title.y = element_text(size=14))+
	theme(axis.text.y = element_text(size=12,colour="black"))+
	theme(axis.title.x = element_text(size=14))+
	theme(axis.text.x = element_text(size=12,colour="black"))+
	geom_hline(yintercept = dset.line$Species[1]/1000, linetype = 2)+
	scale_x_continuous(breaks=c(0,50,100,150,200,250))+scale_y_continuous(breaks=c(0,1,2,3))+
	xlab("No. of genomes")+ ylab("No. of genes (× 1000)")
ggsave(filename="core_pan_accumulate.pdf", height=3.5, width=3.5)
