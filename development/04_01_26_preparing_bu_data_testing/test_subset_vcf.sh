# 
# Shrinking the VCF for testing purposes
# 

# ---- Default for all experiments 
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT=$BASE_DIR #"$BASE_DIR/../../experiment_outputs"

# Experiment naming
EXP_NAME="$(basename "$BASE_DIR")"
EXP_OUTPUT="output_$EXP_NAME"
EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT"

# Create output directory (if needed)
# mkdir -p "$EXP_OUTPUT_PATH"

# Experiment 
RAW_VCF_INPUT="$DATA_LOC/Ebrahimi_3_3_2026_download/minivcf.vcf/minivcf.vcf"

# Note: samples.txt contains the name of the first 50 individuals
IND_MAPPING_FILE="$DATA_LOC/Ebrahimi_3_3_2026_download/mapping.txt"

# Subset to top 50 individuals
head -n 50 $IND_MAPPING_FILE | awk '{print $1}' > samples.txt          # Generates the text with IDs to retain

# Subset 100 random snips
bcftools view -H  $RAW_VCF_INPUT | shuf -n 100 | cut -f1,2 > snps.txt

# Generate subset from samples.txt and snps.txt
bcftools view \
    -S samples.txt \
    -T snps.txt \
    $RAW_VCF_INPUT \
    -Ov -o final_subset.vcf
    # -Oz: output, (z-compressed, v-plain text) 

# Count of samples
bcftools query -l final_subset.vcf.gz | wc -l

# Count number of snps
bcftools view -H final_subset.vcf.gz | wc -l
