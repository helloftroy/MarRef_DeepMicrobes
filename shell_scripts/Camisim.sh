#!/bin/bash --login
#$ -cwd             # Job will run from the current directory
#$ -l nvidia_v100=1               # Will give us 1 GPU to use in our job
#$ -pe smp.pe 8      # 8 CPU cores available to the host code
                         # Can instead use 'nvidia_a100' for the A100 GPUs and then use 12 CPUs

module load libs/cuda

now=$(date)
export OMP_NUM_THREADS=$NSLOTS # This example uses OpenMP for multi-core host code - tell OpenMP how many CPU cores to use.
echo "Start $now"

conda activate CAMISIM

python metagenomesimulation.py MarRef_config.ini 

then=$(date)
echo "Start $now End $then"