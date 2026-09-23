#!/bin/bash
#SBATCH --job-name=helmers-thesis-run-algorithm    # Sets an identifiable name for your job
#SBATCH --partition=cpu                       # Directs the job to the standard CPU partition
#SBATCH --output=batch_result_%j.log      # Saves standard output (%j automatically inserts Job ID)
#SBATCH --nodes=1                   # Number of nodes requested
#SBATCH --ntasks-per-node=1         # Number of tasks per node
#SBATCH --cpus-per-task=125          # Number of CPU cores requested
#SBATCH --mem-per-cpu=8G
#SBATCH --time=06:00:00             # Walltime limit (HH:MM:SS) - keeps queue moving
#SBATCH --mail-type=END                       # Event(s) that triggers email notification (BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=helmerhj@rose-hulman.edu      # Destination email address

# Source the Conda initialization script from your custom local path
source /home/helmerhj/local/bin/miniconda3/etc/profile.d/conda.sh

conda activate r_popgen_env

EXP_ID=$1

bash _str_for_experiment.sh $EXP_ID

mv batch_result_$SLURM_JOB_ID.log "../../data/generated_input/experiment_$EXP_ID"

