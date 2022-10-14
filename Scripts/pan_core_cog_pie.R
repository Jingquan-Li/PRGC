core_pie <- read.table("core_cog.anno", header=F,sep="\t")
pan_pie <- read.table("pan_cog.anno", header=F,sep="\t")
color <- c("grey", "#FFD0B0", "#3370D8", "#CAF5CE", "#CFCD3E", "#3971AB", "#946F35",  "#93c47d","#37AB5B",  "#8C384F","#AAD7ED", "#DEB99B","#EA9527", "#F16E1D","#E1E1E1", "#DC95D8","#5ED2BF","#DA5A5A")
color2 <- c("grey","#B07AAD", "#EAAC5D", "#FFD0B0", "#3370D8", "#CAF5CE", "#CFCD3E", "#3971AB", "#946F35",  "#93c47d","#37AB5B",  "#8C384F","#AAD7ED", "#DEB99B", "#EA9527", "#F16E1D","#DBED92","#E1E1E1", "#DC95D8","#5ED2BF","#DA5A5A")
core_legend <- paste0(core_pie$V1," - ",core_pie$V4)
pan_legend <- paste0(pan_pie$V1," - ",pan_pie$V4)
pdf(file="pan_core_cog.pdf",width=12,height=6.5)
par(mfrow=c(1,2))
par(mai=c(0.1,0.1,0.1,3.2)) ####bottom，left，top，right border
pie(core_pie$V2,core_pie$V1,col = color)

pie(pan_pie$V2,pan_pie$V1,col = color2)

#legend("bottom",pan_legend,cex=0.6,xpd=T,fill=color2)
legend(x=1,y=0.7,pan_legend,cex=0.6,xpd=T,fill=color2)
dev.off()