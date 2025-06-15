#Prepare reference genome sequences for human mRNA and rRNA.
#a. Download hg38 genome sequences from the Gencode website 
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.p13.genome.fa.gz ).
#b. Unzip the downloaded genome file using unzip it into genome folder.
unzip GRCh38.p13.genome.fa.gz
cd genome
  samtools faidx GRCh38.p13.genome.fa
  picard CreateSequenceDictionary R=GRCh38.p13.genome.fa O=GRCh38.p13.genome.dict

cd genome
#a.	Download hg38 transcript sequences from the Gencode website into the genome folder (https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.transcripts.fa.gz ) 
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.transcripts.fa.gz
#b.	 Unzip the file in the genome folder.
unzip gencode.v27.transcripts.fa.gz 
grep ">" gencode.v27.transcripts.fa| awk -F '[\t|]' '{print $6,"\t", $1}'|sed  's/>//' >v27.gene.transcript.txt
cut -f1,2 v27.gene.transcript.txt |awk '{FS="\t"}{a[$1] = a[$1]"\t"$2} END{for (i in a) print i a[i]}' |sort >hg38.gene2transcripts.txt

