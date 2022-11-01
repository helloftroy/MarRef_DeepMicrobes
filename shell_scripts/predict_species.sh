#!/bin/bash --login
#$ -cwd             # Job will run from the current directory
#$ -l nvidia_v100=1               # Will give us 1 GPU to use in our job
#$ -pe smp.pe 8      # 8 CPU cores available to the host code
                         # Can instead use 'nvidia_a100' for the A100 GPUs and then use 12 CPUs

module load libs/cuda # Get the CUDA software libraries and applications 

now=$(date)
echo "Job is using $NGPUS GPU(s) with ID(s) $CUDA_VISIBLE_DEVICES and $NSLOTS CPU core(s)"
export OMP_NUM_THREADS=$NSLOTS # This example uses OpenMP for multi-core host code - tell OpenMP how many CPU cores to use.

source activate DeepMicrobes
export PATH=~/scratch/DeepMicrobes/:$PATH

# run prediction over a for loop
# make sure you are in the folder with the .tfrecs

for i in `ls *.tfrec | sed "s/.tfrec//"`
do
./predict_DeepMicrobes.sh -i "$i".tfrec -b 8192 -l species -p 8 -m ~/scratch/species_3_real_epoch -o ~/scratch/MarRef_benchmark_all/species/three_epoch/"$i"
done

then=$(date)
echo "Start $now End $then"
