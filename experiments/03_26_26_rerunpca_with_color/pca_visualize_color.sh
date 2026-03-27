# Seperated script for visualization since I will be iterating on the graphics a lot.

# ---- Default for all experiments 
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# Experiment naming
EXP_NAME="$(basename "$BASE_DIR")"
EXP_OUTPUT="output_$EXP_NAME"
EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT"

SPP_FILE_LOC=$1

# Visualize PCAs  (data_visualization)
#  inputs: vec file, val file, outdir and name 

# Pruned
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca_color.R \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenvec" \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    1\
    "Pruned_JA_JC" \
    "${SPP_FILE_LOC}"

# Unpruned
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca_color.R \
    "${EXP_OUTPUT_PATH}/PCA_unpruned/PCA_unpruned.eigenvec" \
    "${EXP_OUTPUT_PATH}/PCA_unpruned/PCA_unpruned.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    1\
    "Unpruned_JA_JC" \
    "${SPP_FILE_LOC}"

# Pruned
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca_color.R \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenvec" \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    2\
    "Pruned_JA_JC" \
    "${SPP_FILE_LOC}"

# Pruned
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca_color.R \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenvec" \
    "${EXP_OUTPUT_PATH}/PCA_pruned/PCA_pruned.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    3\
    "Pruned_JA_JC" \
    "${SPP_FILE_LOC}"
