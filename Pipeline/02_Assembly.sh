#!/bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"


############################## de-novo assembly  ############################################
###Single sample assembly using megahit in the metawrap pipeline
Contigs=~/meta/02_assembly/Contigs
metawrap assembly   -1 ${FilterData}/${Sample}_1.fastq   -2 ${FilterData}/${Sample}_1.fastq  -t 36 -m 20  -l  500  -o  ${Sample}_megahit
cp ${Sample}_megahit/final_assembly.fasta   ${Contigs}/${Sample}.fa
######Co-assembly with all tested samples
cat ${filter}/*_1.fastq >All_1.fastq
cat ${filter}/*_2.fastq >All_2.fastq
###need large memory
metawrap assembly   -1 All_1.fastq   -2 All_1.fastq  -t 36 -m 500  -l  500  -o  ${Sample}_megahit
cp ${Sample}_megahit/final_assembly.fasta   ${Contigs}/${Sample}.fa

#get time end the job
echo "Job finished at:" `date`