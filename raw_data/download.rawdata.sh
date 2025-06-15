mkdir -p raw_data/{human,yeast,fly,C4-2}
#Human rRNA:
cd raw_data/human
wget https://sra-pub-src-1.s3.amazonaws.com/SRZ190740/HS_rRNA_dRNA_fast5.tar.gz.1 
#Human IVT (in vitro transcripts): 
wget https://sra-pub-src-1.s3.amazonaws.com/SRZ190744/IVT_Hs_mRNA_fast5.tar.gz.1  
#Yeast rRNA of WT, snoR60, sno61 ad sno62: 
cd raw_data/yeast
wget https://sra-pub-src-1.s3.amazonaws.com/SRZ190768/SC_rRNA_dRNA_fast5.tar.gz.1 
wget https://sra-pub-src-2.s3.amazonaws.com/ERR5317712/RNA475632.fast5.tar.gz.1 
wget https://sra-pub-src-1.s3.amazonaws.com/ERR5317713/RNA475633.fast5.tar.gz.1
wget https://sra-pub-src-2.s3.amazonaws.com/ERR5317714/RNA475634.fast5.tar.gz.1
#Fly rRNA: 
cd raw_data/fly
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR606/ERR6065782/NT_rep1.tar.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR606/ERR6066352/NT_rep2.tar.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR606/ERR6066014/FBL_KD_rep1.tar.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR606/ERR6066353/FBL_KD_rep2.tar.gz
#C4-2 mRNA, include rRNA: 
cd raw_data/C4-2
wget https://sra-pub-src-1.s3.amazonaws.com/SRR20374459/nanopore_siCTRL_rep1.tar.gz.2 
wget https://sra-pub-src-1.s3.amazonaws.com/SRR20374458/nanopore_siCTRL_rep2.tar.gz.2
wget https://sra-pub-src-1.s3.amazonaws.com/SRR20374457/nanopore_siFBL_rep1.tar.gz.2
wget https://sra-pub-src-1.s3.amazonaws.com/SRR20374456/nanopore_siFBL_rep2.tar.gz.2
