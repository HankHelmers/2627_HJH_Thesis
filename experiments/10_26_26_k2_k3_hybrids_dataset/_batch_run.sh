#!/bin/bash
#SBATCH --job-name=helmers-thesis-str-k2-k3     # Sets an identifiable name for your job
#SBATCH --partition=cpu                       # Directs the job to the standard CPU partition
#SBATCH --output=batch_result_%j.log      # Saves standard output (%j automatically inserts Job ID)
#SBATCH --nodes=1                         # Number of nodes requested
#SBATCH --ntasks-per-node=1               # Number of tasks per node
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00                   # Walltime limit (HH:MM:SS) - keeps queue moving
#SBATCH --mail-type=END                       # Event(s) that triggers email notification (BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=helmerhj@rose-hulman.edu      # Destination email address

# Source the Conda initialization script from your custom local path
source /home/helmerhj/local/bin/miniconda3/etc/profile.d/conda.sh

conda activate r_popgen_env

k2_mainparams=/work/williarj/williarj/2627_HJH_Thesis/experiments/10_26_26_k2_k3_hybrids_dataset/mainparams_k2
k3_mainparams=/work/williarj/williarj/2627_HJH_Thesis/experiments/10_26_26_k2_k3_hybrids_dataset/mainparams_k3
extra_param_file=/work/williarj/williarj/2627_HJH_Thesis/experiments/10_26_26_k2_k3_hybrids_dataset/extraparams

LOG_FILE_K2="STR_log_run_large_k2.txt"
LOG_FILE_K3="STR_log_run_large_k3.txt"

# Run K2 in the background
(
    echo "K2 starting..."
    structure -m $k2_mainparams -e $extraparams
    echo "-------------------------------------"
) >> $LOG_FILE_K2 &

# Run K3 in the background
(
    echo "K3 starting..."
    structure -m $k3_mainparams -e $extraparams
) >> $LOG_FILE_K3 &

# Wait for both background jobs to finish before moving on
wait