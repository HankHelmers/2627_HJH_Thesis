#!/bin/bash
#SBATCH --job-name=hjh-thesis-pures-array      # Identifiable job name for the pures dataset
#SBATCH --partition=cpu                       # Directs the job to the standard CPU partition
#SBATCH --output=str_pures_array_%A_%a.log    # Separate log per task (%A=Master ID, %a=Array ID)
#SBATCH --nodes=1                             # One node per task
#SBATCH --ntasks-per-node=1                   # One task per node
#SBATCH --cpus-per-task=1                     # One fully dedicated core per task
#SBATCH --mem=8G                              # 8GB is plenty for an isolated STRUCTURE run
#SBATCH --time=1-00:00:00                     # Max allowed walltime limit for the cpu partition
#SBATCH --array=2-3                           # Submits 2 jobs total: Task 2 (K=2) and Task 3 (K=3)
#SBATCH --mail-type=END,FAIL                  # Alerts you on individual run completions or failures
#SBATCH --mail-user=helmerhj@rose-hulman.edu  # Destination email address

# Source the Conda initialization script from your custom local path
source /home/helmerhj/local/bin/miniconda3/etc/profile.d/conda.sh
conda activate r_popgen_env

# Map the active Slurm Array ID to your K value
K_VAL=$SLURM_ARRAY_TASK_ID

# Dynamically target the correct parameter paths using the K value
MAINPARAMS="/work/williarj/williarj/2627_HJH_Thesis/experiments/10_23_26_k2_k3_pures_dataset/mainparams_k${K_VAL}"
EXTRA_PARAM_FILE="/work/williarj/williarj/2627_HJH_Thesis/experiments/10_23_26_k2_k3_pures_dataset/extraparams"

LOG_FILE="STR_log_run_large_k${K_VAL}.txt"

echo "Starting pures dataset STRUCTURE run for K=${K_VAL} on host $(hostname) at $(date)" > $LOG_FILE

# Run the single structure execution sequentially (no background '&' or 'wait' needed)
structure -m $MAINPARAMS -e $EXTRA_PARAM_FILE >> $LOG_FILE 2>&1

echo "STRUCTURE run for K=${K_VAL} completed at $(date)" >> $LOG_FILE