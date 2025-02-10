#!/bin/bash
samples=("siCTRL_mRNA" "siFBL_mRNA")
conda activate NanoNm
for id in "${samples[@]}"; do
     multi_to_single_fast5 -i "${id}.fast5" -s "$id" --recursive -t 40
     guppy_basecaller --input_path "$id" --save_path "${id}_guppy" --num_callers 40 --recursive --fast5_out --config rna_r9.4.1_70bps_hac.cfg --cpu_threads_per_caller 10
     find "${id}_guppy/workspace/" -name "*.fast5" "${id}_guppy.list"
     python ./NanoNm/extract_raw_and_feature_fast_AUCG.py --cpu=30 --fl="${id}_guppy.list" -o "$id" --clip=5
     python ./NanoNm/predict_sites_Nm.final.py --model ./model -i "$id" -o "${id}_Nm_model" -r  gencode.v27.transcripts.fa -g GRCh38.p13.genome.fa -b hg38.gene2transcripts1.txt
    python ./script/ratio2bed.py  "${id}_Nm_model/ratio.0.5.tsv" siCTRL_mRNA
done

