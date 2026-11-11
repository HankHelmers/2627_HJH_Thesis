#!/bin/bash
#SBATCH --job-name=hjh-thesis-str-array        # Identifiable job name
#SBATCH --partition=cpu                       # Standard CPU partition
#SBATCH --output=str_array_%A_%a.log          # Separate log per task (%A=Master ID, %a=Array ID)
#SBATCH --nodes=1                             # One node per task
#SBATCH --ntasks-per-node=1                   # One task per node
#SBATCH --cpus-per-task=1                     # One core per task (fully dedicated)
#SBATCH --mem=8G                              # 8GB is plenty for a single K run
#SBATCH --time=1-00:00:00                     # Pure 24-hour limit per run
#SBATCH --array=2-3                           # Submits 2 jobs total (Task 2 and Task 3)
#SBATCH --mail-type=END,FAIL                  # Notifies you on individual run status
#SBATCH --mail-user=helmerhj@rose-hulman.edu

# Source the Conda initialization script
source /home/helmerhj/local/bin/miniconda3/etc/profile.d/conda.sh
conda activate r_popgen_env

# Use the Slurm Array ID variable to dynamically pick the correct parameters file
K_VAL=$SLURM_ARRAY_TASK_ID
MAINPARAMS="/work/williarj/williarj/2627_HJH_Thesis/experiments/10_26_26_k2_k3_hybrids_dataset/mainparams_k${K_VAL}"
EXTRA_PARAM_FILE="/work/williarj/williarj/2627_HJH_Thesis/experiments/10_26_26_k2_k3_hybrids_dataset/extraparams"

LOG_FILE="STR_log_run_large_k${K_VAL}.txt"

echo "Starting STRUCTURE run for K=${K_VAL} on host $(hostname) at $(date)" > $LOG_FILE

# Execute the isolated task sequentially 
structure -m $MAINPARAMS -e $EXTRA_PARAM_FILE >> $LOG_FILE 2>&1

echo "STRUCTURE run for K=${K_VAL} completed at $(date)" >> $LOG_FILE