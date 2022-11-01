#!/bin/bash --login
#$ -cwd             # Job will run from the current directory
#$ -l nvidia_v100=1               # Will give us 1 GPU to use in our job
#$ -pe smp.pe 8      # 8 CPU cores available to the host code
                         # Can instead use 'nvidia_a100' for the A100 GPUs and then use 12 CPUs

module load libs/cuda

now=$(date)

export OMP_NUM_THREADS=$NSLOTS # This example uses OpenMP for multi-core host code - tell OpenMP how many CPU cores to use.
echo "Job is using $NGPUS GPU(s) with ID(s) $CUDA_VISIBLE_DEVICES and $NSLOTS CPU core(s)"

source activate DeepMicrobes
export PATH=~/scratch/DeepMicrobes/:$PATH
export PATH=~/localscratch/DeepMicrobes/:$PATH


# Copy a directory of files from scratch to the GPU node's local NVMe storage
cp -r ~/scratch/DeepMicrobes ~/localscratch
cp -r ~/scratch/MarRef.speciestrain.tfrec ~/localscratch

# Process the data with a GPU app, from within the local NVMe storage area
cd ~/localscratch
mkdir species_2_real_epoch
cp ~/scratch/species_3_epoch/* species_2_real_epoch

#run prediction
./DeepMicrobes/DeepMicrobes.py --num_classes 914 --input_tfrec ~/localscratch/MarRef.speciestrain.tfrec --train_epochs 1 --num_gpus 1 --model_name attention --cpus 8 --batch_size 4096 --model_dir ~/localscratch/species_2_real_epoch

# Copy the results back to the main scratch area
cp -r species_2_real_epoch ~/scratch

# Tidy-up the local NVMe storage on the GPU node
rm -rf ~/localscratch/DeepMicrobes
rm -rf ~/localscratch/MarRef.speciestrain.tfrec
rm -rf ~/localscratch/species_2_real_epoch

then=$(date)
echo "Start $now End $then"

# to run
# qsub run_training_test.sh
