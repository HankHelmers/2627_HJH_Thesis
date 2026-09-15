#!/bin/bash
#SBATCH --job-name=helmers-thesis-simulation-1     # Sets an identifiable name for your job
#SBATCH --partition=cpu                       # Directs the job to the standard CPU partition
#SBATCH --output=result_%j.log      # Saves standard output (%j automatically inserts Job ID)
#SBATCH --nodes=1                   # Number of nodes requested
#SBATCH --ntasks-per-node=1         # Number of tasks per node
#SBATCH --cpus-per-task=2           # Number of CPU cores requested
#SBATCH --time=01:00:00             # Walltime limit (HH:MM:SS) - keeps queue moving
#SBATCH --mail-type=END                       # Event(s) that triggers email notification (BEGIN,END,FAIL,ALL)
#SBATCH --mail-user=helmerhj@rose-hulman.edu      # Destination email address

conda activate r_popgen_env

bash _experiment_generation.sh 1

