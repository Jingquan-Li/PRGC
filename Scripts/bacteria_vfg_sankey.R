table <- read.table("bacteria_top100_vfg_num.tab",header = F,sep = "\t")
genus_species <- table[c('V6','V7','V8')]
names(genus_species) <- c('source', 'target', 'Freq')
family_genus <- aggregate(table$V8, by = list(table$V5, table$V6), FUN = sum)
names(family_genus) <- c('source', 'target', 'Freq')
order_family <- aggregate(table$V8, by = list(table$V4, table$V5), FUN = sum)
names(order_family) <- c('source', 'target', 'Freq')
class_order <- aggregate(table$V8, by = list(table$V3, table$V4), FUN = sum)
names(class_order) <- c('source', 'target', 'Freq')
phylum_class <- aggregate(table$V8, by = list(table$V2, table$V3), FUN = sum)
names(phylum_class) <- c('source', 'target', 'Freq')
kingdom_phylum <- aggregate(table$V8, by = list(table$V1, table$V2), FUN = sum)
names(kingdom_phylum) <- c('source', 'target', 'Freq')
link_list <- rbind(kingdom_phylum,phylum_class, class_order, order_family, family_genus,genus_species)

library(reshape2)
node_list <- reshape2::melt(table, id = 'V8')
node_list <- node_list[!duplicated(node_list$value), ]
link_list$IDsource <- match(link_list$source, node_list$value) - 1
link_list$IDtarget <- match(link_list$target, node_list$value) - 1

library(networkD3)

p <- sankeyNetwork(Links = link_list, Nodes = node_list,
		   Source = 'IDsource', Target = 'IDtarget', Value = 'Freq',
		   NodeID = 'value', NodeGroup = 'variable', 
		   fontSize = 12, sinksRight = FALSE,width = 1200,height = 800)
##### delete the same html file if it exist

saveNetwork(p,"Bacteria_level_Sankey.html")
library(webshot)

webshot("Bacteria_level_Sankey.html","Bacteria_level_top100_vf_Sankey.pdf",vwidth = 1200,vheight=800)
