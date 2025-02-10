#!/bin/bash
samples=("siCTRL_rRNA" "siFBL_rRNA")
conda activate NanoNm
for id in "${samples[@]}"; do
    multi_to_single_fast5 -i "${id}.fast5" -s "$id" --recursive -t 40
    guppy_basecaller --input_path "$id" --save_path "${id}_guppy" --num_callers 40 --recursive --fast5_out    --config rna_r9.4.1_70bps_hac.cfg --cpu_threads_per_caller 10
    tombo resquiggle --rna --overwrite "${id}_guppy/workspace/" human.rRNA.fa --processes 40 --fit-global-scale --include-event-stdev
    find "${id}_guppy/workspace/" -name "*.fast5" "${id}_guppy.list"
    python ./NanoNm/extract_raw_and_feature_fast_AUCG.py --cpu=30 --fl="${id}_guppy.list" -o "${id}_guppy.feature" --clip=5
python ./NanoNm/predict_sites_Nm.final.py --model /home/ch220806/2-O-Me/NanoNm/model --cpu 10 -i all -o rRNA_QC7 -r human.rRNA.fa   -g human.rRNA.fa  -b rRNA_gene2transcript.txt 2rRNA.QC7.err
python ./scripts/ratio2bed.py  rRNA_QC7/ratio.0.5.tsv "$sample"
done

