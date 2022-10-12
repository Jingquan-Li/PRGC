#!/bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"

###################################Part1: Reads QC #################################################
###Reads quality control by fastp
RawData=~/data/Rawdata/
CleanData=~/data/Cleandata/
fastp -i ${RawData}/${Sample}_1.fq.gz  -I ${RawData}/${Sample}_2.fq.gz \
	    -o ${CleanData}/${Sample}_1.qc.fq.gz  -O  ${CleanData}/${Sample}_2.qc.fq.gz  \
	       -5 -W 4 -M 20 -n 5 -c -l 50 -w 12 -h ${Sample}.html

###Remove host DNA sequence

INDEX=~/db/Sscrofa
bowtie2_out=~/data/bowtie2_out
##build index
bowtie2-bulid Sscrofa11.1.fa Sscrofa11.1
##mapping to the pig reference genome
bowtie2 -x ${INDEX}/Sscrofa11.1 -p 15  -1 ${CleanData}/${Sample}_1.qc.fq.gz   -2 ${CleanData}/${Sample}_2.qc.fq.gz \
       	| samtools view -@2 -bS -o ${bowtire2_out}/${Sample}.bam

##extract unmapped reads
samtools view -@15  -bf 12 -F 256 ${bowtire2_out}/${Sample}.bam \
	|samtools sort  -@3 -n  -o ${bowtire2_out}/${Sample}_bothEndsUnmapped_sorted.bam 

###convert the bam file to fastq file
fiilter_data=~/data/filter_data
bedtools bamtofastq -i ${bowtire2_out}/${Sample}_bothEndsUnmapped_sorted.bam \
	-fq ${FilterData}/${Sample}_1.fastq -fq2 ${FilterData}/${Sample}_2.fastq

##############################Part2: de-novo assembly  ############################################
###Single sample assembly using megahit in the metawrap pipeline
Contigs=~/meta/02_assembly/Contigs
metawrap assembly   -1 ${FilterData}/${Sample}_1.fastq   -2 ${FilterData}/${Sample}_1.fastq  -t 36 -m 20  -l  500  -o  ${Sample}_megahit
cp ${Sample}_megahit/final_assembly.fasta   ${Contigs}/${Sample}.fa
######Co-assembly with all the tested samples
cat ${filter}/*_1.fastq >All_1.fastq
cat ${filter}/*_2.fastq >All_2.fastq
###need large memory
metawrap assembly   -1 All_1.fastq   -2 All_1.fastq  -t 36 -m 500  -l  500  -o  ${Sample}_megahit
cp ${Sample}_megahit/final_assembly.fasta   ${Contigs}/${Sample}.fa
############################Part3: gene catalog reconstruction ####################################
###gene prediction using Prodigal
catalog=~/meta/03_gene_catalog
gene_prediction=~/meta/03_gene_catalog/gene_prediction
prodigal  -a ${gene_prediction}/${Sample}_protein.faa -d ${gene_prediction}/${Sample}_nucleotide_seq.fna \
       	-o ${gene_prediction}/${Sample}_gene_gff  -m -f gff  -p meta -i  ${Contigs}/${Sample}.fa

####summary of the protein sequence 
cd ${catalog}
cat ${gene_prediction}/*_protein.faa  >total_protein.faa
bash gene_info_deal.sh  total_protein.faa

###dereplication at protein level (identity:100%-90%-50%)
cd-hit -i total_protein.faa -o total.protein.faa.100 -c 1.00 -n 5 -M 80000 -d 0 -T 16 
cd-hit -i total.protein.faa.100 -o total.protein.faa.90 -c 0.90 -s 0.8 -n 5 -M 40000 -g 1 -d 0 -T 16
cd-hit  -i total.protein.faa.90 -o total.protein.faa.50 -c 0.5 -s 0.8 -n 3 -M 40000 -g 1 -d 0 -T 16

###extract PRGC90 gene list
cat total.protein.faa.90|grep "^>"|awk -F ' ' '{print $1}'|awk -F '>' '{print $2}' >PRGC90_geneID.list
#extract the nucleotide sequence of PRGC90 by sequence ID
seqkit grep    -f PRGC90_geneID.list total_nucleotide_seq.fna > PRGC90_cds.fna

###taxonomy of the catalog
#Index of Uniprot TrEMBL database
Database=~/db/Uniprot_tremble
taxonomy=~/meta/03_gene_catalog/Taxonomy
diamond makedb --in ${Database}/uniprot_trembl.fasta  -d ${Database}/uniprot_trembl
#aligning protein sequence of gene catalog to the Uniprot TrEMBL database
diamond  blastp -q total.protein.faa.100 -d ${Database}/uniprot_trembl.dmnd   -p 36   -e 1e-5 -k 50 --id 30 --sensitive  -o ${taxonomy}/total.protein.faa.100.diamond2uniprot_tremb
#taxonomic classification based on the LCA algorithms using BASTA
basta  sequence -l 25 -i 80 -e 0.00001 -m 3 -b 1 -p 60 ${taxonomy}/total.protein.faa.100.diamond2uniprot_trembl ${taxonomy}/PLGC100.diamond2uniprot_trembl.dmnd.lca.out  prot

############################Part4: Binning ########################################
###single sample binning
binning=~/meta/04_binning/bins
cd ${binning}  && mkdir ${Sample}/
cd ${Sample}
#binning with three tools with the Binning module
metawrap binning -o ${binning}/INITIAL_BINNING -t 36 -a ${Contigs}/${Sample}.fa   -l 500 --metabat2 --maxbin2  --concoct \
      	--universal  ${FilterData}/${Sample}*fastq
#Consolidate bin sets with the Bin_refinement module
metawrap bin_refinement -o ${binning}/BIN_REFINEMENT -t 12 -A INITIAL_BINNING/metabat2_bins/   -B INITIAL_BINNING/maxbin2_bins  -C INITIAL_BINNING/concoct_bins/ -c 50  -x  10 --quick

#Re-assemble the consolidated bin set with the Reassemble_bins module
metawrap reassemble_bins -o BIN_REASSEMBLY \
	-1 ${FilterData}/${Sample}_1.fastq \
	-2 ${FilterData}/${Sample}_2.fastq \
	-t 20 \
	-m 60 \
	-c 50\
	-x 10 \
	-b BIN_REFINEMENT/metawrap_50_10_bins

###Co-binnng
cd cd ${binning}  && mkdir All/
cd All/
#using metaba2 and maxbin2 tools in metawrap
metawrap binning -o INITIAL_BINNING -t 36 -a ${Contigs}/All.fa   -l 500 --metabat2 --maxbin2  --concoct \
--universal  ${FilterData}/All*fastq
###binning using vamb
vamb --outdir vamb_bins --fasta INITIAL_BINNING/work_files/assembly.fa --jgi INITIAL_BINNING/work_files/metabat_depth.txt \
        -o k --minfasta 200000 -m 500
#bins refinement
metawrap bin_refinement -o BIN_REFINEMENT -t 12 -A INITIAL_BINNING/metabat2_bins/   -B INITIAL_BINNING/maxbin2_bins \
       	-C INITIAL_BINNING/vamb_bins/ -c 50  -x  10 --quick


metawrap reassemble_bins -o BIN_REASSEMBLY \
	-1 ${FilterData}/All_1.fastq \
	-2 ${FilterData}/All_2.fastq \
	-t 20 \ 
	-m 300 \ 
	-c 50\
	-x 10 \ 
	-b BIN_REFINEMENT/metawrap_50_10_bins
cd ../
###extract MAGs  conform to the threholds of 50% completeness and 10% contamination
MAGs=~/meta/04_binning/MAGs
for  filename   in  ${Contigs}/*.fa
do     
	base=$(basename $filename .fa)
       	for   i  in  ${binning}/${base}/BIN_REASSEMBLY/reassembled_bins/*.fa
       	do     
	       	bin=${i#*.}
       		cp ${i} ${MAGs}/${base}.${bin}    
	done
done

###deplicated bins at 99% and 95% ANI
dRep99=~/meta/04_binning/drep/drep99
dRep95=~/meta/04_binning/drep/drep95
dRep dereplicate ${dRep99} -g ${MAGs}/*.fa -p 16 -d -comp 50 -con 10 -nc 0.25 -pa 0.9 -sa 0.99
dRep dereplicate ${dRep95} -p 16 -comp 50 -con 10 -nc 0.25 -pa 0.9 -sa 0.95 -g ${MAGs}/*.fa


###Taxonomic annotation of MAGs  using gtdb-tk
taxonomy=~/meta/04_binning/taxonomy
gtdbtk classify_wf --cpus 36 --out_dir ${taxonomy}/gtdbtk_all --genome_dir ${MAGs}  --extension fa

#get time end the job
echo "Job finished at:" `date`
