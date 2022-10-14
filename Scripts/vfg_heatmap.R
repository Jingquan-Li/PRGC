vfs <- read.table("vfg_freq_absent.tab",sep="\t", header=T,row.names=1,check.names=F,quote="")
meta <- read.table("MAGs_285_cluster_k2.txt",sep="\t", header=F,row.names=1,check.names=F,quote="")
names(meta) <-"Clade"
colors <- c("#000000", "#FFFB00")
col_anno <- meta
ann_colors <- list(Clade=c(`CladeⅠ`="#FFAE4C",`CladeⅡ`="#4C924C"))
col_order  <- order(meta[,1])
col_names <- rownames(meta)[col_order]
pheatmap::pheatmap(vfs[,col_names],
		   annotation_col  =col_anno, cluster_cols = F, legend=F,annotation_legend = F,  annotation_colors = ann_colors,
		   fontsize=10,fontsize_row=8,show_colnames = F, show_rownames = F,cluster_rows = F, color = colors,
		   filename="pheatmap_vfg.pdf",width=9,height=4)
