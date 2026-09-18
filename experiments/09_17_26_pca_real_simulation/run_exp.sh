#!/bin/bash
#SBATCH --job-name=helmers-pca    # Sets an identifiable name for your job
#SBATCH --partition=cpu                       # Directs the job to the standard CPU partition
#SBATCH --nodes=1                   # Number of nodes requested
#SBATCH --ntasks-per-node=1         # Number of tasks per node
#SBATCH --cpus-per-task=25           # Number of CPU cores requested
#SBATCH --time=02:00:00             # Walltime limit (HH:MM:SS) - keeps queue moving

# Source the Conda initialization script from your custom local path
source /home/helmerhj/local/bin/miniconda3/etc/profile.d/conda.sh

conda activate r_popgen_env

# ---- Default for all experiments 
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT="$BASE_DIR"

REAL_VCF_FILE_LOC="$DATA_LOC/raw_input/Ebrahimi_3_3_2026_prepared/renamed_pure_jc_ja.vcf"
SIM_VCF_FILE_LOC="$DATA_LOC/generated_input/experiment_0_1/boot1/vcf/with_hybrids.vcf.gz"

LOG_FILE="$OUTPUT_ROOT/log.txt"
echo "" > "$LOG_FILE"

$SCRIPTS_LOC/data_analysis/pca_vcf.sh \
    "PCA_real_unpruned" \
    $REAL_VCF_FILE_LOC \
    $OUTPUT_ROOT >> $LOG_FILE

$SCRIPTS_LOC/data_analysis/pca_vcf.sh \
    "PCA_sim_unpruned" \
    $SIM_VCF_FILE_LOC \
    $OUTPUT_ROOT >> $LOG_FILE
