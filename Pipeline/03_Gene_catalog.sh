#!/bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"

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

#get time end the job
echo "Job finished at:" `date`