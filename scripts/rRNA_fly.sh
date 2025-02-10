#!/bin/bash 
samples=("Fly_NT_rep1" "Fly_NT_rep2" "Fly_KD_rep1" "Fly_KD_rep2")
for id in "${samples[@]}"; do
	gunzip "${id}_guppy.feature.feature.*.gz" 
	python NanoNm/predict_sites_Nm.yeast.py  --model NanoNm/model --cpu 20  -i ${id}_guppy.feature -o $id\_Nm_model -r  fly.rRNA.fa  -g fly.rRNA.fa -b fly_rRNA.list
    python ./script/ratio2bed.py $id\_Nm_model/ratio.0.5.tsv $id\_fly  
 done
