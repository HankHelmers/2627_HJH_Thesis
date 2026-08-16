# ----
# Computes PCA for an input VCF file into output location; 
# Extracts only the calls identified in specified "EXTRACT_CALLS" file.
# This was added for the LD pruned versus non-pruned versions.
# 
# Inputs 
#   - #1: pca_title
#   - #2: data, Full file location to VCF location (in data)
#   - #3: output, Full file location to output (in experiments_output)

# Get inputs
PCA_NAME=$1
VCF_LOC=$2
EXTRACT_CALLS=$3
EXP_OUTPUT_LOC=$4

# echo "$PCA_NAME" 
# echo "$EXP_OUTPUT_LOC/$PCA_NAME"

# Run 
plink --vcf "$VCF_LOC" --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract "$EXTRACT_CALLS" \
--make-bed --pca --out "$EXP_OUTPUT_LOC/$PCA_NAME"

# Make output directory, move into output dir 
mkdir -p "$EXP_OUTPUT_LOC/$PCA_NAME"
mv "$EXP_OUTPUT_LOC/$PCA_NAME."* "$EXP_OUTPUT_LOC/$PCA_NAME"

