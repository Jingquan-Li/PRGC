#!/bin/bash
cd vfdb_out/
#for i in *.vfdb.tab; do  base=$(basename $i .vfdb.tab); python ../blast_best.py  $i   ${base}.vfdb.best; done

for i in *.vfdb.best; do  base=$(basename $i .vfdb.best); awk 'BEGIN{FS=OFS="\t"}{print $1, $2}' $i|awk -F"(" '{print $1}' >${base}.vfg.tab; done

##########sed -i 's/ \t/\t/' vfg_anno

cat *.vfg.tab|awk -F"\t" '{print $2}' |sort -u >vfg_all_uniq.txt
for i in *vfg.tab 
do
    base=$(basename $i .vfg.tab); awk -F"\t" '{print $2}' $i >${base}.vfg.anno
done
for j in *.vfg.anno
do
    base=$(basename $j .vfg.anno)
    cat vf_all_uniq.txt|while read i 
    do         
	    grep -w "^${i}$"  $j;         if [[ $? -eq 0 ]]
    then      
	    echo "1" >>${base}.vfg.freq.txt
    else  echo "0" >>${base}.vfg.freq.txt         
    fi     
    done
done

paste vfg_all_uniq.txt  *.vfg.freq.txt > ../vfg_freq_abesent.tab

ls *vfdb.tab|sed  ":a;N;s/\n/\t/g;ta"|sed 's/.vfdb.tab//g' |sed  's/^/ID\t/' >../head
cd ../
cat vfg_freq_abesent.tab  >>head
mv head vfg_freq_abesent.tab
