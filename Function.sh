#/bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"
Database=~/db/
function=~/meta/03_gene_catalog
cd ${function}
mkdir eggNOG KEGG dbCAN2 VFDB
###eggNOG
#Index
cd ${Database}/eggnog
diamond makedb --in eggnog.db  -d eggnog_proteins

INPUT=~/meta/03_gene_catalog/total.protein.faa.90

cd ${function}/
time emapper.py -m diamond --no_annot --no_file_comments --data_dir ${Database}/eggnog --evalue 1e-5 \
	      --cpu 12 -i ${INPUT} -o eggNOG/PRGC90 --override
time emapper.py --annotate_hits_table  eggNOG/PRGC90.emapper.seed_orthologs --no_file_comments \
	     --seed_ortholog_evalue 1e-5  -o eggNOG/ --cpu 16 --data_dir ${Database}/eggnog  --override

###VFDB
#Index
makeblastdb -in  VFDB_setB_pro.fas   -parse_seqids -hash_index -dbtype prot -out  VFDB
#blastp
cd ${function}/VFDB/
blastp -query ${INPUT} -db ${Database}/VFDB/VFDB -out PRGC90.vfdb.tab -evalue 1e-5 -outfmt 6 -num_threads 16 -num_alignments 5
###extract best hit 
python  blast_best.py  PRGC90.vfdb.tab   PRGC90.vfdb.best.tab
###CAZY annotation
#format HMM db
hmmpress dbCAN-HMMdb-V10.txt
#hmmscan
cd ${function}/dbCAN2
hmmscan -o PRGC90.dbcan --tblout PRGC90.dbcan.tab -E 1e-5 --cpu 16 ${Database}/dbCAN/dbCAN-HMMdb-V10.txt  ${INPUT}

###KEGG annotation  using kobas
cd ${function}/KEGG
diamond blastp -d ${Database}/kobas-3.0/seq_pep/ko.pep.fasta.dmnd -q ${INPUT} -e 0.00001 --outfmt 6 -o PRGC.keggout.dmnd --threads 24

annotate.py  -i PRGC.keggout.dmnd -t blastout:tab -s ko -k  ${Database}/kobas-3.0 -o PRGC90.kegg.anno.txt -n 12


#get time end the job
echo "Job finished at:" `date`


