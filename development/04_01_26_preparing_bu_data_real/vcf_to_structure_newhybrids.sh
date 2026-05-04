#
# Full pipeline used for extracting the parsing the data needed for running 
# STRUCTURE and NEWHYBRIDS from a VCF. 
#
# Input a VCF and outputs a prepared STRUCTURE.str (one row format) and NEWHYBRIDS.nh files
#
# Recognizing that I will likely need to do this again, a generalized version
# will be necessary in the future. 
#
#

# INPUTS: --------------------------------------------------
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"

INPUT_VCF_FILE="$DATA_LOC/Ebrahimi_3_3_2026_download/minivcf.vcf.gz"  #[insert input path]
PREPARED_OUTPUT_PATH="$DATA_LOC/Ebrahimi_3_3_2026_prepared" #[insert output path]

FINAL_STRUCTURE_FILE_NAME="pure_jc_ja"

mkdir $PREPARED_OUTPUT_PATH


# DATA specific: --------------------------------------------------
# Create a copy of VCF with generalized ID names, generates mapping.txt
"$SCRIPTS_LOC/data_preparation/vcf_inds_rename.sh" \
    $INPUT_VCF_FILE \
    $PREPARED_OUTPUT_PATH \
    "renamed_$FINAL_STRUCTURE_FILE_NAME"

# Subsample a specific number of individuals and loci using mapping.txt
"$SCRIPTS_LOC/data_preparation/vcf_subset_inds_loci.sh" \
    $INPUT_VCF_FILE \
    $PREPARED_OUTPUT_PATH/mapping.txt \
    50 \
    100 \
    "subsampled_$FINAL_STRUCTURE_FILE_NAME" \
    $PREPARED_OUTPUT_PATH

# Collecting the JA versus JC Ids
Rscript "$SCRIPTS_LOC/data_preparation/subset_JCvsJA_ebrahimi.R"


# General VCF to STRUCTURE EXTRACTION --------------------------------------------------
# Note: I didn't end up needing to replace the original individual IDS to get structure 
#       to run. However, the renaming scripts may be useful for later graph making, so 
#       they are still available below in "DATA specific" functions. 

# Structure format for all data
"$SCRIPTS_LOC/data_preparation/vcf_to_structure.sh" \
    $INPUT_VCF_FILE \
    $PREPARED_OUTPUT_PATH \
    $FINAL_STRUCTURE_FILE_NAME.str

# Structure format for subset of data
"$SCRIPTS_LOC/data_preparation/vcf_to_structure.sh" \
    "$PREPARED_OUTPUT_PATH/subsampled_$FINAL_STRUCTURE_FILE_NAME.vcf.gz" \
    $PREPARED_OUTPUT_PATH \
    "subsampled_$FINAL_STRUCTURE_FILE_NAME.str"

# General VCF to NEWHYBRIDS EXTRACTION --------------------------------------------------
# Note: NH conversion Relies on python pyenv setup 

# Newhybrids format for all data
python3 "$SCRIPTS_LOC/data_preparation/vcf_to_newhybrids.py" \
    -i "$INPUT_VCF_FILE" \
    -o "$PREPARED_OUTPUT_PATH/$FINAL_STRUCTURE_FILE_NAME.nh"

# Newhybrids format for subset of data
python3 "$SCRIPTS_LOC/data_preparation/vcf_to_newhybrids.py" \
    -i "$PREPARED_OUTPUT_PATH/subsampled_$FINAL_STRUCTURE_FILE_NAME.vcf.gz" \
    -o "$PREPARED_OUTPUT_PATH/subsampled_$FINAL_STRUCTURE_FILE_NAME.nh"


