# Comprehensive catalogs for microbial genes and metagenome-assembled genomes of the swine lower respiratory tract microbiome 
This repository contains scripts and data that used for characterizing respiratory microbiome of the manuscript "Comprehensive catalogs for microbial genes and metagenome-assembled genomes of the swine lower respiratory tract microbiome elucidate the relationship of microbial species with lung lesions".

## Catalogs construction
Consruction of genes  and MAGs catalogs for pig lower respiratory microbiome.

<b>Requirements:</b>
* [fastp](https://github.com/OpenGene/fastp) (tested v0.20.1)
* [Bowtie2](https://github.com/BenLangmead/bowtie2) (tested v2.3.5.1) 
* [SAMtools](https://github.com/samtools/samtools) (tested v1.7)
* [MEGAHIT](https://github.com/voutcn/megahit) (tested v1.2.9)
* [prodigal](https://github.com/hyattpd/Prodigal) (tested v2.6.3)
* [CD-HIT](https://github.com/weizhongli/cdhit) (tested v4.8.1)
* [Diamond](https://github.com/bbuchfink/diamond) (tested v2.0.12.150)
* [BASTA](https://github.com/timkahlke/BASTA) (tested v1.3)
* [blast](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/) (tested v2.12.0)
* [MetaBAT2](https://bitbucket.org/berkeleylab/metabat) (tested v2.15)
* [Maxbin2](http://sourceforge.net/projects/maxbin) (tested v2.2.7)
* [CONCOCT](https://github.com/BinPro/CONCOCT) (tested v0.5.0)
* [metaWRAP](https://github.com/bxlab/metaWRAP) (tested v1.3.2)
* [CheckM](https://ecogenomics.github.io/CheckM)(tested v1.0.18)
* [metaSPAdes](https://github.com/ablab/spades) (tested v3.13.0)
* [VAMB](https://github.com/RasmussenLab/vamb) (tested v3.0.2)
* [dRep](https://github.com/MrOlm/drep) (tested v3.2.2)
* [GTDB-Tk](https://github.com/Ecogenomics/GTDBTk) (tested v1.7.0)

## Abundance
Codes used to calculate the abundance of genes and metagenome-assembled genomes.<br> 
<b>Requirements:</b>
* [BWA MEM2](https://github.com/lh3/bwa) (tested v2.2.1) 
* [SAMtools](https://github.com/samtools/samtools) (tested v1.7)
* [FeatureCounts](http://bioinf.wehi.edu.au/featureCounts) (tested v2.0.1)
* [metaWRAP](https://github.com/bxlab/metaWRAP) (tested v1.3.2)
## Function
Script to perform functional annotation.<br> 
<b>Requirements:</b>
* [EggNOG mapper](https://github.com/jhcepas/eggnog-mapper) (tested v2.6.1)	
* [HMMER](https://github.com/guyz/HMM) (tested v3.1b2)
* [KOBAS](http://kobas.cbi.pku.edu.cn/kobas3) (tested v3.0.3)
* [Diamond](https://github.com/bbuchfink/diamond) (tested v2.0.12.150)
* [blast](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/) (tested v2.12.0)

## Figure 1-6 and Sfigures/
* Associated data for statistical analysis and visualization.

## Other analysis and plotting scripts
* `gene_Freq_Abundance_Counts.py`:Calcultaed the gene presence in 745 tested samples. 
* `blast_best.py`:Extracted the best blast results of VFDB alignment.
* `vfg.freq.absent.sh`: Find the presence or absence of virulence factor genes in the *Mycoplasma hyopneumoniae* genomes.
* `gene_info_deal.sh`: Statistic for gene information.

<b>R Scripts/</b>
* `sequence_depth_hist.R`: The histogram of sequencing depth in raw data and clean data.
* `gene_accumulation.R`: Plot the gene accumulation curve in the PRGC90.
* `gene_range_stats.r`: Statistics of the genes relative abundance in different ranges.
* `Items _proportion.R`: The proportion of shraed items in all samples.
* `HL_SVLL_top20_species.R`: Plot the top20 species in relative abudance in healthy lung samples and severe lung-lesion samples.
* `MAG_taxa_count.R`: Plots of the MAGs taxonomic proportions.
* `sgb_usgb.R`: The numbers of SGB and the proportion of uSGB in 18 phylum.
* `MAG_quality.R`: Plots of the MAGs quality.
* `pan_core_gene_accumulation.R`: The accumulation cuvers of the pan-genes and core-genes.
* `pan_core_cog_pie.R` COG annotaion of the pan-genes and core-genes.
* `mds_ani.R`:  Multidimensional Scaling analysis based  on the average nucleotide identity.
* `pan_core_top20ko_bar.R`: The 20 KEGG pathways with the largest number of annotated genes in pan-genes and core-genes.
* `function_clade_compare.R`: Comparison of the numbers of annotated functional genes in two *Mycoplasma hyopneumoniae* clades.
* `vfg_heatmap.R`: Distribution of virulence factor genes in 285 *Mycoplasma hyopneumoniae* genomes.
* `diversity_box.R`: Alpha and beta diversity of lung microbiome in the F7 population.
* `Kingdom.R`: Average species composition of virus, fungi, and archaea kingdom and the proportion of different kingdom.
