# Integrated protocol for mapping 2’-O-Methylation using Nanopore direct RNA-seq data with NanoNm

# Citation
If using the software in a publication, please cite the following:

Yanqiang Li et.al 2′-O-methylation at internal sites on mRNA promotes mRNA stability. Molecular Cell (2024)
https://www.cell.com/molecular-cell/abstract/S1097-2765(24)00326-5

# Dataset used in this protocol:

Please download the necessery dataset such as example_data.zip of test fast5 for human rRNA and mRNA dataset, and feature files of yeast and fly in Yeast_Fly_feature_dataset.zip from 10.5281/zenodo.14632831  (wget command also supported as below). 
The description of these folders are as below: 
## ./genome: The folder used to store genome and annotation files for the Nm detection in mRNA.
## ./raw_data: The folder used to store the raw data of fast5 files downloaded for the processing.
## ./example_data: The toy fast5 files of human mRNA and rRNA used for the star protocol.
## ./rRNA: The rRNA information for human, yeast and fly.
## ./scripts: Custom scripts for star protocols from https://github.com/kaifuchenlab/STAR_Protocol/.
## ./Yeast_Fly_feature_dataset: The processed feature dataset for yeast and fly.

Nanopore Raw Datasets were also listed as below (These dataset are large and optional for STAR Protocol): 
        
## Download the necessery dataset with wget:
```
wget https://zenodo.org/records/14632831/files/rRNA.zip?download=1
```
```
wget https://zenodo.org/records/14632831/files/example_data.zip?download=1
```
```
wget https://zenodo.org/records/14632831/files/Yeast_Fly_feature_dataset.zip?download=1 
```        
## Below are optional:              
## Human rRNA:
```
cd raw_data
wget  https://sra-pub-src-1.s3.amazonaws.com/SRZ190740/HS_rRNA_dRNA_fast5.tar.gz.1 
```
Human IVT : 
```
wget https://sra-pub-src-1.s3.amazonaws.com/SRZ190744/IVT_Hs_mRNA_fast5.tar.gz.1  
```
## Yeast  rRNA: 
WT: 
```
wget https://sra-pub-src-1.s3.amazonaws.com/SRZ190768/SC_rRNA_dRNA_fast5.tar.gz.1 
```
snR60KO:
```
wget  https://sra-pub-src-2.s3.amazonaws.com/ERR5317712/RNA475632.fast5.tar.gz.1 
```
sno61KO:
```
wget https://sra-pub-src-1.s3.amazonaws.com/ERR5317713/RNA475633.fast5.tar.gz.1
```
sno61KO:
```
wget https://sra-pub-src-2.s3.amazonaws.com/ERR5317714/RNA475634.fast5.tar.gz.1
```
## Fly rRNA: 
```
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR606/ERR6066014/FBL_KD_rep1.tar.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR606/ERR6065782/NT_rep1.tar.gz
```
## Human prostate cancer cell line C4-2 mRNA, include rRNA: 
```
wget  https://sra-pub-src-1.s3.amazonaws.com/SRR20374459/nanopore_siCTRL_rep1.tar.gz.2 
wget  https://sra-pub-src-1.s3.amazonaws.com/SRR20374458/nanopore_siCTRL_rep2.tar.gz.2
wget https://sra-pub-src-1.s3.amazonaws.com/SRR20374457/nanopore_siFBL_rep1.tar.gz.2
wget https://sra-pub-src-1.s3.amazonaws.com/SRR20374457/nanopore_siFBL_rep1.tar.gz.2 
```
# Reference of dataset:
1. Begik, O., Lucas, M.C., Pryszcz, L.P., Ramirez, J.M., Medina, R., Milenkovic, I., Cruciani, S., Liu, H., Vieira, H.G.S., Sas-Chen, A., et al. (2021). Quantitative profiling of pseudouridylation dynamics in native RNAs with nanopore sequencing. Nat Biotechnol 39, 1278-1291. 10.1038/s41587-021-00915-6
        
        
        
        
        
        
        
        
        
             
2. Sklias, A., Cruciani, S., Marchand, V., Spagnuolo, M., Lavergne, G., Bourguignon, V., Brambilla, A., Dreos, R., Marygold, S.J., Novoa, E.M., et al. (2024). Comprehensive map of ribosomal 2'-O-methylation and C/D box snoRNAs in Drosophila melanogaster. Nucleic Acids Res. 10.1093/nar/gkae139
        
        
        
        
        
        
        
        
        
        
3. Jenjaroenpun, P., Wongsurawat, T., Wadley, T.D., Wassenaar, T.M., Liu, J., Dai, Q., Wanchai, V., Akel, N.S., Jamshidi-Parsian, A., Franco, A.T., et al. (2021). Decoding the epitranscriptional landscape from native RNA sequences. Nucleic Acids Res 49, e7. 10.1093/nar/gkaa620
        
        
        
        
        
        


# The Flowchart of NanoNm
<p>Flowchart of a machine learning model to detect Nm based on Nanopore direct RNA-seq.</p>
<img src='./Picture1.png' style='margin-left: auto; margin-right: auto;display: block;'></img>

# Step0. Install the conda environment first
```
conda env create -f Nanopore.environment.yml      #install conda environment
conda install -c bioconda ont-fast5-api #install ont-fast5 for multi_to_single_fast5
install guppy_basecaller #download software from Nanopore community.
conda install -c bioconda ont-tombo #install tombo 
```
# Step1. Extract the features of Nanopore direct RNA-seq of rRNA.
# $id means sample of each fast5 file
## 1.1 Split the multiple fast5 to single fast5 files
```
multi_to_single_fast5  -i ${id}.fast5 -s $id  --recursive -t 40
```
## 1.2 Base calling using guppy_basecaller
```
guppy_basecaller --input_path $id --save_path $id_guppy --num_callers 40 --recursive --fast5_out --config rna_r9.4.1_70bps_hac.cfg  --cpu_threads_per_caller 10
```
## 1.3 Resquiggle the signal of fast5 files to each transcript
```
tombo resquiggle --rna --overwrite  ${id}\_guppy/workspace/  human_uniq.rRNA.fa    --processes 40 --fit-global-scale --include-event-stdev 
```
## 1.4 Feature calling of each transcripts
```
find  ${id}\_guppy/workspace/ -name "*.fast5" >${id}_guppy.list
python extract_raw_and_feature_fast_AUCG.py  --cpu=30 --fl = ${id}_guppy.list -o ${id}_guppy.feature --clip=5
```
## 1.5 Map the reads to the rRNA
```
minimap2  -ax map-ont -uf -k14 -x splice -t 20 human_uniq.rRNA.fa    ${id}_guppy.feature.feature.fa|samtools view -@ 20 -bS - |samtools sort -@ 20 -     >${id}.rRNA.sort.bam
sam2tsv -r ./rRNA/human_uniq.rRNA.fa   ${id}.rRNA.sort.bam >${id}.rRNA.sort.bam.tsv
```
## 1.6 Extract the features of fast5 files of Nm sites in rRNA
```
python  filter_get.fast5.py  -i ${id}.rRNA.sort.bam.tsv -b rRNA.Nm1.bed  -f ${id}_guppy.feature.feature.tsv -o ${id}.fast5.rRNA.signal.txt   >${id}.rRNA.feature.anno.txt
```
# Step2. Training the 2'-O-methylation model from the Nanopore direct RNA-seq of rRNA
```
cat kmer.txt|xargs -i -e echo "python train_model_scale_pos_weight_Nm.py  {} >>Auc.scale1.txt & " |sh
```
# Step3. Predict the 2'-O-methylation in the mRNA
```

#downloaded gencode.v27.transcripts.fa  from https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.transcripts.fa.gz


multi_to_single_fast5  -i ${id}.fast5 -s $id  --recursive -t 40

guppy_basecaller --input_path $id --save_path $id_guppy --num_callers 40 --recursive --fast5_out --config rna_r9.4.1_70bps_hac.cfg  --cpu_threads_per_caller 10

tombo resquiggle --rna --overwrite  ${id}\_guppy/workspace/  gencode.v27.transcripts.fa    --processes 40 --fit-global-scale --include-event-stdev 


python extract_raw_and_feature_fast_AUCG.py  --cpu=30 --fl = ${id}_guppy.list -o ${id}_guppy.feature --clip=5

cat *.feature.feature.fa >all.feature.fa

cat *.feature.feature.tsv >all.feature.tsv 

python predict_sites_Nm.final.py   --model ./model --cpu 20  -i all -o all_Nm_model -r  gencode.v27.transcripts.fa  -g GRCh38.p13.genome.fa  -b hg38.gene2transcripts.txt 
```

# Step4. Map the 2'-O-methylation in the yeast rRNA
```
#!/bin/bash
samples=("WT" "snoR60" "snoR61" "sno62")
for id in "${samples[@]}"; do
        gunzip "${id}_guppy.feature.feature.*.gz"
    python ./NanoNm/predict_sites_Nm.yeast.py  --model ./NanoNm/model --cpu 20  -i ${id}_guppy.feature -o $id\_Nm_model -r  yeast.rRNA.fa  -g yeast.rRNA.fa -b yeast_rRNA.list
        python ./script/ratio2bed.py $id\_Nm_model/ratio.0.5.tsv $id\_yeast
 done
```

# Step5. Map the 2'-O-methylation in the fly rRNA
```
#!/bin/bash
samples=("Fly_NT_rep1" "Fly_NT_rep2" "Fly_KD_rep1" "Fly_KD_rep2")
for id in "${samples[@]}"; do
        gunzip "${id}_guppy.feature.feature.*.gz"
        python NanoNm/predict_sites_Nm.yeast.py  --model NanoNm/model --cpu 20  -i ${id}_guppy.feature -o $id\_Nm_model -r  fly.rRNA.fa  -g fly.rRNA.fa -b fly_rRNA.list
    python ./script/ratio2bed.py $id\_Nm_model/ratio.0.5.tsv $id\_fly
 done
```

# Step6. Map the 2'-O-methylation in rRNA of human nanopore test dataset

```
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
```


# Step7. Map the 2'-O-methylation in mRNA of human nanopore test dataset

```
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
```

# Step8. Combine the rRNA and mRNA ratio files from the two samples, siFBL and siCTRL

```
python ./scripts/merge_mRNA.py siCTRL_mRNA.filter.bed siFBL_mRNA.filter.bed Human_mRNA.ratio.txt
python ./scripts/merge_human.rRNA.py human.rRNA.Nm.bed siCTRL_rRNA.filter.bed siFBL_rRNA.filter.bed Human_rRNA.ratio.txt
Rscript ./scripts/Human_siFBL_siCTRL_rRNA_mRNA.plot.R
```
# Contact
Yanqiang.Li@childrens.harvard.edu

or

Kaifu.Chen@childrens.harvard.edu


Copy Right @ Kaifu Chen Lab @ Boston Childrens Hospital / Harvard Medical School
