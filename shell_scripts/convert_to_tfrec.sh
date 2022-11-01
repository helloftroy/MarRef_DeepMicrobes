#!/bin/bash --login
#$ -cwd             # Job will run from the current directory
#$ -l nvidia_v100=1               # Will give us 1 GPU to use in our job
#$ -pe smp.pe 8      # 8 CPU cores available to the host code
                         # Can instead use 'nvidia_a100' for the A100 GPUs and then use 12 CPUs

module load libs/cuda

#To convert fastq/fasta to TFRecord for prediction:

#tfrec_predict_kmer.sh -f sample_R1.fastq -r sample_R2.fastq -t fastq -v /path/to/vocab/tokens_merged_12mers.txt -o sample_name -s 4000000 -k 12
#Arguments: 
#-f Fastq/fasta file of forward reads 
#-r Fastq/fasta file of reverse reads 
#-v Absolute path to the vocabulary file (path/to/vocab/tokens_merged_12mers.txt) 
#-o Output name prefix 
#-s (Optional) Number of sequences per file for splitting (default: 4000000) 
#-k (Optional) k-mer length (default: 12) 
#-t (Optional) Sequence type fastq/fasta (default: fastq)



now=$(date)
export OMP_NUM_THREADS=$NSLOTS # This example uses OpenMP for multi-core host code - tell OpenMP how many CPU cores to use.
echo "Start $now"

source activate DeepMicrobes
export PATH=~/scratch/DeepMicrobes/:$PATH
export PATH=~/scratch/DeepMicrobes/bin:$PATH
export PATH=~/scratch/DeepMicrobes/scripts:$PATH
export PATH=~/scratch/DeepMicrobes/pipelines:$PATH

#i=SRR13122067_1.fastq
#ACC=`echo SRR13122067_1.fastq | cut -d "." -f1 | cut -d "_" -f2`
## Training set uses -rs 808, testing set uses -rs 747
#./tfrec_predict_kmer.sh -f SRR13122067_1.fastq -r SRR13122067_2.fastq -t fastq -v ~/scratch/bioproject_Bio_GO_SHIP/K12.kmers.txt -o name.speciestest -s 40000000 -k 12
#echo "acc is $ACC"



for i in `ls *.fastq`
do
ACC=`echo $i | cut -d "_" -f1`
./tfrec_predict_kmer.sh -f "$ACC"_1.fastq -r "$ACC"_2.fastq -t fastq -v ~/scratch/bioproject_Bio_GO_SHIP/K12.kmers.txt -o "$ACC".speciestest -s 40000000 -k 12
done

then=$(date)
echo "Start $now End $then"


# for i in `ls *.tfrec | sed "s/_*.tfrec//"`

