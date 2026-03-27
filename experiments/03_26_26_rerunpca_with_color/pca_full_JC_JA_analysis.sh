# ----
# Conducting initial PCA on Ebrahimi 03-03 data
# This data was only 'pures', so keep that in mind.
# 
# 1. Generates a linkage pruned and unpruned versions.
# 2. Computes PCA for provided data 
# 3. Generates png of graphs for the provided data. 
# 
# Note: The scripts used assumes currently inside an experiment folder. 
# ----


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

# ----INPUT
# Location and name of VCF file within the data folder 
# Ex: "Ebrahimi_3_3_2026_download/minivcf.vcf.gz"
VCF_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_download/minivcf.vcf.gz"
SPP_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_download/JA_JC_labels.txt"


# Create output directory (if needed)
mkdir -p "$EXP_OUTPUT_PATH"

# ---- Experiment

# Missing data in VCF (data_preparation)
#   Input: data and output locations
$SCRIPTS_LOC/data_preparation/missing_vcf.sh \
    $VCF_FILE_LOC \
    $EXP_OUTPUT_PATH

# Prune for linkage, generate both and in out versions (data_preparation)
#   Input: data and output locations
$SCRIPTS_LOC/data_preparation/linkage_pruning.sh \
    $VCF_FILE_LOC \
    $EXP_OUTPUT_PATH

# # Run PCA (pruned and unpruned) (data_analysis)
#   Inputs: pca_name, data and output locations
#   OUT ARE THE ONES TO BE REMOVED 
$SCRIPTS_LOC/data_analysis/pca_vcf.sh \
    "PCA_unpruned" \
    $VCF_FILE_LOC \
    $EXP_OUTPUT_PATH

$SCRIPTS_LOC/data_analysis/pca_vcf_extracted.sh \
    "PCA_pruned" \
    $VCF_FILE_LOC \
    $EXP_OUTPUT_PATH/linkage_pruning/linkage.prune.in \
    $EXP_OUTPUT_PATH

# Visualize PCAs  (data_visualization)
#   Created a seperate file for this to enable easy iterating on the process
#   as I design the graphs themselves. 
./pca_visualize_color.sh $SPP_FILE_LOC
