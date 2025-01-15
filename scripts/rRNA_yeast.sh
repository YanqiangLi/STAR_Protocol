




python predict_sites_Nm.yeast.py   --model ./model --cpu 20  -i all -o $id\_Nm_model -r  yeast.rRNA.fa  -g yeast.rRNA.fa -b yeast_rRNA.list
python ~/script/ratio2bed.py  $id\_Nm_model/ratio.0.5.tsv $id\_yeast  

