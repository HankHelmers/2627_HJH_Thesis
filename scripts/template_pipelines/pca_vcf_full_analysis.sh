# ----
# Conducts a PCA of an inputed VCF. 
# 
# 1. Generates a linkage pruned and unpruned versions.
# 2. Computes PCA for provided data 
# 3. Generates png of graphs for the provided data. 
# 
# ----
# To run:
#   Create a new experiment folder to act as the home for this experiment.   
#   Then create a copy of this pipeline script and add to the experiment.
#   Add the VCF_FILE_LOC
#   And run as normal command: ./pca_vcf_full_analysis.sh
#
# Input: 
# Location and name of VCF file within the data folder 
# Ex: "Ebrahimi_3_3_2026_download/minivcf.vcf.gz"
VCF_FILE_LOC="INSERT DATA"


# ----------------------------------------------------------------
# ---- Default for all experiments 
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# Experiment naming based on folder
EXP_NAME="$(basename "$BASE_DIR")"
EXP_OUTPUT="output_$EXP_NAME"
EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT"

# Create output directory (if needed)
mkdir -p "$EXP_OUTPUT_PATH"

# ---- Experiment

# Missing data in VCF (data_preparation)
#   Input: data and output locations
$SCRIPTS_LOC/data_preparation/missing_vcf.sh \
    $DATA_LOC/$VCF_FILE_LOC \
    $EXP_OUTPUT_PATH

# Prune for linkage, generate both and in out versions (data_preparation)
#   Input: data and output locations
$SCRIPTS_LOC/data_preparation/linkage_pruning.sh \
    $DATA_LOC/$VCF_FILE_LOC \
    $EXP_OUTPUT_PATH

# # Run PCA (pruned and unpruned) (data_analysis)
#   Inputs: pca_name, data and output locations
$SCRIPTS_LOC/data_analysis/pca_vcf_extracted.sh \
    "PCA_unpruned" \
    $DATA_LOC/$VCF_FILE_LOC \
    $EXP_OUTPUT_PATH/linkage_pruning/linkage.prune.in \
    $EXP_OUTPUT_PATH

$SCRIPTS_LOC/data_analysis/pca_vcf_extracted.sh \
    "PCA_pruned" \
    $DATA_LOC/$VCF_FILE_LOC \
    $EXP_OUTPUT_PATH/linkage_pruning/linkage.prune.out \
    $EXP_OUTPUT_PATH

# Visualize PCAs  (data_visualization)
# Pruned
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca.R \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenvec" \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    "PCA_pruned"

# Unpruned
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca.R \
    "${EXP_OUTPUT_PATH}/PCA_unpruned/PCA_unpruned.eigenvec" \
    "${EXP_OUTPUT_PATH}/PCA_unpruned/PCA_unpruned.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    "PCA_unpruned"
