#bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"
################################Part1: abundance of gene catalog ###################################
filterdata=~/data/filter_data
catalog=~/meta/03_gene_catalog
abundance=~/meta/03_gene_catalog/Abundance
cd ${abundance}
###summary of the gene;
bash gene_info_deal.sh   ${catalog}/total.protein.faa.90
###generate the SAF file for FeatureCounts
awk 'BEGIN{FS=OFS="\t"} {print $2,$2,$3,$4,$5}' total.protein.faa.90.txt  >total.protein.faa.90.saf
sed -i 's/\tGeneID/\tChr/' total.protein.faa.90.saf
SAF=~/meta/03_gene_catalog/Abundance/total.protein.faa.90.saf
mkdir Gene
###Gene abundance
cd Gene/
mkdir sam sort_bam flagstat abundance
#Index bulid for catalog
bwa index ${catalog}/PRGC90_cds.fna 
#mapping to the catalog
bwa-mem2 mem -M -Y -t 36 -o ${Sample}.sam ${catalog}/PRGC90_cds.fna \
	${filter}/${Sample}_1.fastq ${filter}/${Sample}_2.fastq 
#convert to BAM file
samtools sort -@ 16 -o ${Sample}.sort.bam  ${Sample}.sam  
#sequence stats
samtools flagstat -@ 16  ${Sample}.sort.bam > ${Sample}.flag

#counts	 
featureCounts -T 16 -p -M -O  -a $SAF -F SAF  -o ${Sample}.counts ${Sample}.sort.bam 

mv *.sam      ${abundance}/Gene/sam/
mv *sort.bam   ${abundance}/Gene/sort_bam/
mv *.flag   ${abundance}/Gene/flagstat/
mv *counts*  ${abudnance}/Gene/abundance/
#relative abudnance 
cd ${abudnance}/Gene/abundance/
awk  '{if(NR>1){print $1"\t"$NF/($(NF-1))}else{print $1"\t"$NF}}' \
	${Sample}.counts > ${Sample}.copynumber.txt

awk '{if(NR>1){if(NR==FNR){N+=$NF}else{if(FNR==1)print $1"\t"$NF;else print $1"\t"$NF/N}}}' \
	${Sample}.copynumber.txt ${Sample}.copynumber.txt >${Sample}.relative.txt


#merge all samples
paste -d '\t' *relative.txt|awk -F"\t" 'BEGIN{OFS="\t"}{for(i=2;i<=NF;i=i+2){printf "%s\t", $i}; printf "\n"}' \
       	>${abundance}/genecatalog_bwa_relative.txt



########################################Part2: MAGs abundance ##################################################
###calculate MAGs abundance in the metawrap quant_bins module
MAG_abundance=~/meta/04_binning/abundance
dRep99=~/meta/04_binning/drep/drep99
metawrap quant_bins -b ${dRep99}/dereplicated_genomes  -t 16 \
	-o ${MAG_abundance}/QUANT_BINS    ${filterdata}/*fastq 

#get time end the job
echo "Job finished at:" `date`

