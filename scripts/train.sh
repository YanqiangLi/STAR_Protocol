cat kmer.txt|xargs -i -e echo "grep {}  all.feature.mod.tsv >{}.mod.tsv”
cat kmer.txt|xargs -i -e echo "grep {}  all.feature.unmod.tsv >{}.unmod.tsv”
cat kmer.txt|xargs -i -e echo "python train_model_scale_pos_weight_Nm.py {} >>Auc.scale1.txt & " |sh
