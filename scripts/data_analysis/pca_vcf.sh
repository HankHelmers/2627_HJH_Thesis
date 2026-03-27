# ----
# Computes PCA for an input VCF file into output location; 
# DOES NOT EXTRACT any changes --> pca_vcf_extact.sh
# This was added for the LD pruned versus non-pruned versions.
# 
# Inputs 
#   - #1: pca_title
#   - #2: data, Full file location to VCF location (in data)
#   - #3: output, Full file location to output (in experiments_output)

# Get inputs
PCA_NAME=$1
VCF_LOC=$2
EXP_OUTPUT_LOC=$3

# echo "$PCA_NAME" 
# echo "$EXP_OUTPUT_LOC/$PCA_NAME"

# Run 
plink --vcf "$VCF_LOC" --double-id --allow-extra-chr --set-missing-var-ids @:# \
--make-bed --pca --out "$EXP_OUTPUT_LOC/$PCA_NAME"

# Make output directory, move into output dir 
mkdir -p "$EXP_OUTPUT_LOC/$PCA_NAME"
mv "$EXP_OUTPUT_LOC/$PCA_NAME."* "$EXP_OUTPUT_LOC/$PCA_NAME"


# Example call from 03_24_26

# # ---- Default for all experiments 
# BASE_DIR="$(pwd)"            # Base directory (where script is run from)
# SCRIPTS_LOC="$BASE_DIR/../../scripts"
# DATA_LOC="$BASE_DIR/../../data"
# OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# # Experiment naming based on folder
# EXP_NAME="$(basename "$BASE_DIR")"
# EXP_OUTPUT="output_$EXP_NAME"
# EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT"

# $SCRIPTS_LOC/data_analysis/pca_vcf.sh \
#     "PCA_unpruned" \
#     $DATA_LOC/$VCF_FILE_LOC \
#     $EXP_OUTPUT_PATH
