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

FILE_NAME=$1

# Visualize PCAs  (data_visualization)
#  inputs: vec file, val file, outdir and name 
 
Rscript $SCRIPTS_LOC/data_visualization/visualize_pca.R \
    "${EXP_OUTPUT_PATH}/$FILE_NAME/$FILE_NAME.eigenvec" \
    "${EXP_OUTPUT_PATH}/$FILE_NAME/$FILE_NAME.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    1 \
    $FILE_NAME

Rscript $SCRIPTS_LOC/data_visualization/visualize_pca.R \
    "${EXP_OUTPUT_PATH}/$FILE_NAME/$FILE_NAME.eigenvec" \
    "${EXP_OUTPUT_PATH}/$FILE_NAME/$FILE_NAME.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    2 \
    $FILE_NAME

Rscript $SCRIPTS_LOC/data_visualization/visualize_pca.R \
    "${EXP_OUTPUT_PATH}/$FILE_NAME/$FILE_NAME.eigenvec" \
    "${EXP_OUTPUT_PATH}/$FILE_NAME/$FILE_NAME.eigenval" \
    "${EXP_OUTPUT_PATH}/" \
    3 \
    $FILE_NAME