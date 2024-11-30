#!/bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"

################################### Reads QC #################################################
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
	
#get time end the job
echo "Job finished at:" `date`
