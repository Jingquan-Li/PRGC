#!/bin/bash
# Kill script if any commands fail
set -e
echo "Job Start at `date`"


############################ Binning ########################################
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
metawrap binning -o INITIAL_BINNING -t 36 -a ${Contigs}/All.fa   -l 500 --metabat2 --maxbin2   \
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