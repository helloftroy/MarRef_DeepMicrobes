# De-interleave fastq files
#$ -l nvidia_v100=1               # Will give us 1 GPU to use in our job
#$ -pe smp.pe 8

#gzip -d reads_mapping.tsv.gz
#gzip -d anonymous_reads.fq.gz

echo "Splitting fastq into R1"
time cat anonymous_reads.fq | awk 'BEGIN{s=0}{if (s==0){print;} if (NR%4==0){s=(s+1)%2;} }' >R1.fq
echo "Splitting fastq into R2"
time cat anonymous_reads.fq | awk 'BEGIN{s=0}{if (s==1){print;} if (NR%4==0){s=(s+1)%2;} }' >R2.fq

echo "Converting to TF format"
time tfrec_predict_kmer.sh -f R1.fq -r R2.fq -t fastq -v K12.kmers.txt -o anonymous -s 100000 -k 12