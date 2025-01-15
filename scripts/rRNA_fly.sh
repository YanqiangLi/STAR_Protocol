python predict_sites_Nm.final.py   --model ./model --cpu 20  -i all -o $id_Nm_model -r  fly.rRNA.fa  -g fly.rRNA.fa -b fly_rRNA.list
python ~/script/ratio2bed.py $id_Nm_model/ratio.0.5.tsv $id\_fly  

