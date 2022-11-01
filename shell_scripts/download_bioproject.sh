#!/bin/bash --login
#$ -cwd             # Job will run from the current directory
#$ -l nvidia_v100=1               # Will give us 1 GPU to use in our job
#$ -pe smp.pe 8      # 8 CPU cores available to the host code
                         # Can instead use 'nvidia_a100' for the A100 GPUs and then use 12 CPUs

module load libs/cuda #for GPU
module load tools/env/proxy #for being able to download files

now=$(date)

export OMP_NUM_THREADS=$NSLOTS # This example uses OpenMP for multi-core host code - tell OpenMP how many CPU cores to use.
echo "Job is using $NGPUS GPU(s) with ID(s) $CUDA_VISIBLE_DEVICES and $NSLOTS CPU core(s)"

source activate DeepMicrobes
export PATH=~/scratch/DeepMicrobes/:$PATH
export PATH=~/localscratch/DeepMicrobes/:$PATH
export PATH=$PATH:$PWD/sratoolkit.3.0.0-centos_linux64/bin

vdb-config --prefetch-to-cwd

File = "biogeo_SRR_Acc_List.txt"
Lines = $(cat $File)

for Line in $Lines
do
    echo "$Line"
done
#prefetch SRR13122036 --max-size 420000000000
#fasterq-dump --progress SRR13122036

then=$(date)
echo "Start $now End $then"