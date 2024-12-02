# Comprehensive catalogs for microbial genes and metagenome-assembled genomes of the swine lower respiratory tract microbiome 
This repository contains scripts and data that used for characterizing respiratory microbiome of the manuscript "Comprehensive lung microbial gene and genome catalogs reveal the mechanism survey of *Mesomycoplasma hyopneumoniae* strains causing pig lung lesions".

## Pipeline/
### Catalogs construction
Consruction of genes  and MAGs catalogs for pig lower respiratory microbiome.

<b>Requirements:</b>
* [fastp](https://github.com/OpenGene/fastp) (tested v0.20.1)
* [Bowtie2](https://github.com/BenLangmead/bowtie2) (tested v2.3.5.1) 
* [SAMtools](https://github.com/samtools/samtools) (tested v1.7)
* [MEGAHIT](https://github.com/voutcn/megahit) (tested v1.2.9)
* [prodigal](https://github.com/hyattpd/Prodigal) (tested v2.6.3)
* [CD-HIT](https://github.com/weizhongli/cdhit) (tested v4.8.1)
* [Diamond](https://github.com/bbuchfink/diamond) (tested v2.0.12.150)
* [BASTA](https://github.com/timkahlke/BASTA) (tested v1.4.1)
* [blast](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/) (tested v2.12.0)
* [MetaBAT2](https://bitbucket.org/berkeleylab/metabat) (tested v2.15)
* [Maxbin2](http://sourceforge.net/projects/maxbin) (tested v2.2.7)
* [CONCOCT](https://github.com/BinPro/CONCOCT) (tested v0.5.0)
* [metaWRAP](https://github.com/bxlab/metaWRAP) (tested v1.3.2)
* [CheckM](https://ecogenomics.github.io/CheckM)(tested v1.0.18)
* [metaSPAdes](https://github.com/ablab/spades) (tested v3.13.0)
* [VAMB](https://github.com/RasmussenLab/vamb) (tested v3.0.2)
* [dRep](https://github.com/MrOlm/drep) (tested v3.2.2)
* [GTDB-Tk](https://github.com/Ecogenomics/GTDBTk) (tested v2.1.0)

### Abundance
Codes used to calculate the abundance of genes and metagenome-assembled genomes.<br> 
<b>Requirements:</b>
* [BWA MEM2](https://github.com/lh3/bwa) (tested v2.2.1) 
* [SAMtools](https://github.com/samtools/samtools) (tested v1.7)
* [FeatureCounts](http://bioinf.wehi.edu.au/featureCounts) (tested v2.0.1)
* [metaWRAP](https://github.com/bxlab/metaWRAP) (tested v1.3.2)
### Function
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
* `vfg.freq.absent.sh`: Find the presence or absence of virulence factor genes in the *Mesomycoplasma hyopneumoniae* genomes.
* `gene_info_deal.sh`: Statistic for gene information.
