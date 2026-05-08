# INPUTS: --------------------------------------------------
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"

INPUT_VCF_FILE="$DATA_LOC/Ebrahimi_3_3_2026_download/minivcf.vcf.gz"  #[insert input path]
PREPARED_OUTPUT_PATH="$DATA_LOC/Ebrahimi_3_3_2026_subsets" #[insert output path]

RENAMED_VCF_FILE_1=$PREPARED_OUTPUT_PATH/"1_renamed_inds_original.vcf"
SUBSAMPLED_IND_VCF_FILE_2=$PREPARED_OUTPUT_PATH/"2_subsampled_top10.vcf"
SUBSAMPLED_LOCI_VCF_FILE_3=$PREPARED_OUTPUT_PATH/"3_subsampled_top10_loci10.vcf"

mkdir $PREPARED_OUTPUT_PATH

# DATA specific: --------------------------------------------------
# 0. Create a copy of VCF with generalized ID names, generates mapping.txt
# "$SCRIPTS_LOC/data_preparation/vcf_inds_rename.sh" \
#     $INPUT_VCF_FILE \
#     $PREPARED_OUTPUT_PATH \
#     $RENAMED_VCF_FILE_1 #1_renamed_inds_original.vcf

# 2. Subset 10 random loci
"$SCRIPTS_LOC/data_preparation/vcf_subset_random_loci.sh" \
    $SUBSAMPLED_IND_VCF_FILE_2 \
    $PREPARED_OUTPUT_PATH/mapping.txt \
    $PREPARED_OUTPUT_PATH/samples.txt \
    10 \
    $SUBSAMPLED_LOCI_VCF_FILE_3 \
    $PREPARED_OUTPUT_PATH 