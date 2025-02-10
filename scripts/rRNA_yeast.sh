#!/bin/bash
samples=("WT" "snoR60" "snoR61" "sno62")
for id in "${samples[@]}"; do
	gunzip "${id}_guppy.feature.feature.*.gz" 
    python ./NanoNm/predict_sites_Nm.yeast.py  --model ./NanoNm/model --cpu 20  -i ${id}_guppy.feature -o $id\_Nm_model -r  yeast.rRNA.fa  -g yeast.rRNA.fa -b yeast_rRNA.list
   	python ./script/ratio2bed.py $id\_Nm_model/ratio.0.5.tsv $id\_yeast  
 done
