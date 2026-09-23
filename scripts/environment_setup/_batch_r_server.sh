#!/bin/bash
#SBATCH --job-name=helmers-thesis-simulation-1     # Sets an identifiable name for your job
#SBATCH --partition=cpu                       # Directs the job to the standard CPU partition
#SBATCH --nodes=1                   # Number of nodes requested
#SBATCH --ntasks-per-node=1         # Number of tasks per node
#SBATCH --cpus-per-task=100           # Number of CPU cores requested
#SBATCH --time=02:00:00             # Walltime limit (HH:MM:SS) - keeps queue moving

# Source the Conda initialization script from your custom local path
source /home/helmerhj/local/bin/miniconda3/etc/profile.d/conda.sh

conda activate r_popgen_env

# Remember to call squeue -u helmerhj and identify the correct server
# On home computer: ssh -N -L 8787:{server}:8787 helmerhj@slurm.csse.rose-hulman.edu
#  ssh -N -L 8787:gauss:8787 helmerhj@slurm.csse.rose-hulman.edu
# Browser: http://localhost:8787
~/rstudio-server-local/usr/lib/rstudio-server/bin/rserver \
  --server-daemonize=0 \
  --www-port=8787 \
  --secure-cookie-key-file=$HOME/rstudio-server-data/secure-cookie-key \
  --server-pid-file=$HOME/rstudio-server-data/rserver.pid \
  --server-data-dir=$HOME/rstudio-server-data \
  --database-config-file=$HOME/rstudio-server-data/database.conf \
  --rsession-which-r=$(which R) \
  --rsession-ld-library-path=$CONDA_PREFIX/lib \
  --server-user=$USER
