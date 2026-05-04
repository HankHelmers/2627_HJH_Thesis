#
# Full pipeline XXXX
#
#

# INPUTS: --------------------------------------------------
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"

INPUT_VCF_FILE="$DATA_LOC/Ebrahimi_3_3_2026_download/minivcf.vcf.gz"  #[insert input path]
PREPARED_OUTPUT_PATH="$DATA_LOC/Ebrahimi_3_3_2026_subsets" #[insert output path]

RENAMED_VCF_FILE_1=$PREPARED_OUTPUT_PATH/"1_renamed_inds_original.vcf"
SUBSAMPLED_IND_VCF_FILE_2=$PREPARED_OUTPUT_PATH/"2_subsampled_top10.vcf"
SUBSAMPLED_LOCI_VCF_FILE_3=$PREPARED_OUTPUT_PATH/"3_subsampled_top10_loci200.vcf"
RANDOMIZED_SUBSAMPLED_LOCI_ALL_VCF_FILE_4=$PREPARED_OUTPUT_PATH/"4_all_loci_randomized_subsample_top10.vcf"
RANOMIDZED_SUBSAMPLED_LOCI_VCF_FILE_5=$PREPARED_OUTPUT_PATH/"5_200_loci_randomized_subsample_top10.vcf"

mkdir $PREPARED_OUTPUT_PATH

# DATA specific: --------------------------------------------------
# 0. Create a copy of VCF with generalized ID names, generates mapping.txt
"$SCRIPTS_LOC/data_preparation/vcf_inds_rename.sh" \
    $INPUT_VCF_FILE \
    $PREPARED_OUTPUT_PATH \
    $RENAMED_VCF_FILE_1 #1_renamed_inds_original.vcf

# 1. Subsample top 10 individuals, all loci
bcftools query -l $RENAMED_VCF_FILE_1 | head -n 10 > $PREPARED_OUTPUT_PATH/samples.txt
bcftools query -l $RENAMED_VCF_FILE_1 
bcftools view -S $PREPARED_OUTPUT_PATH/samples.txt $RENAMED_VCF_FILE_1 -o $SUBSAMPLED_IND_VCF_FILE_2

# Optional: Collecting the JA versus JC Ids
# Rscript "$SCRIPTS_LOC/data_preparation/subset_JCvsJA_ebrahimi.R"

# 2. Subset 200 random loci
"$SCRIPTS_LOC/data_preparation/vcf_subset_random_loci.sh" \
    $SUBSAMPLED_IND_VCF_FILE_2 \
    $PREPARED_OUTPUT_PATH/mapping.txt \
    $PREPARED_OUTPUT_PATH/samples.txt \
    200 \
    $SUBSAMPLED_LOCI_VCF_FILE_3 \
    $PREPARED_OUTPUT_PATH 

# 3. Randomize some loci in the original and subset versions
# Randomize some loci in the subsampled individuals with ALL loci
# python3 "$SCRIPTS_LOC/data_preparation/vcf_random_changes.py" \
#     -i "$SUBSAMPLED_IND_VCF_FILE_2" \
#     -o "$RANDOMIZED_SUBSAMPLED_LOCI_ALL_VCF_FILE_4.vcf"

# Randomize some loci in the subsampled loci VCF
python3 "$SCRIPTS_LOC/data_preparation/vcf_random_changes.py" \
    -i "$SUBSAMPLED_LOCI_VCF_FILE_3" \
    -o "$RANOMIDZED_SUBSAMPLED_LOCI_VCF_FILE_5"

# General VCF to STRUCTURE EXTRACTION --------------------------------------------------
# Note: I didn't end up needing to replace the original individual IDS to get structure 
#       to run. However, the renaming scripts may be useful for later graph making, so 
#       they are still available below in "DATA specific" functions. 

# 3 - original subset individuals & loci
# Structure format for subset of data
"$SCRIPTS_LOC/data_preparation/vcf_to_structure.sh" \
    $SUBSAMPLED_LOCI_VCF_FILE_3 \
    $PREPARED_OUTPUT_PATH \
    ${SUBSAMPLED_LOCI_VCF_FILE_3::-4}.str # remove the last four characters for same name, diff extension

# General VCF to NEWHYBRIDS EXTRACTION --------------------------------------------------
# Note: NH conversion Relies on python pyenv setup 

# Newhybrids format for subset of data
python3 "$SCRIPTS_LOC/data_preparation/vcf_to_newhybrids.py" \
    -i $SUBSAMPLED_LOCI_VCF_FILE_3 \
    -o ${SUBSAMPLED_LOCI_VCF_FILE_3::-4}.nh


# 5 - randomized subset individuals & loci
# Structure format for subset of data
"$SCRIPTS_LOC/data_preparation/vcf_to_structure.sh" \
    $RANOMIDZED_SUBSAMPLED_LOCI_VCF_FILE_5 \
    $PREPARED_OUTPUT_PATH \
    ${RANOMIDZED_SUBSAMPLED_LOCI_VCF_FILE_5::-4}.str # remove the last four characters for same name, diff extension
    
# General VCF to NEWHYBRIDS EXTRACTION --------------------------------------------------
# Note: NH conversion Relies on python pyenv setup 

# Newhybrids format for subset of data
python3 "$SCRIPTS_LOC/data_preparation/vcf_to_newhybrids.py" \
    -i $RANOMIDZED_SUBSAMPLED_LOCI_VCF_FILE_5 \
    -o ${RANOMIDZED_SUBSAMPLED_LOCI_VCF_FILE_5::-4}.nh


