
# ----------------------------- Default for all experiments
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# ----------------------------- INPUTS
# STRUCTURE
# STR_DATA_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_top10_randomized/Ebrahimi_3_3_2026_top10_randomized.str.str"
# MAIN_PARAMS_LOC="$SCRIPTS_LOC/data_generation/template_structure_mainparams.txt"
# EXTRA_PARAMS_LOC="$SCRIPTS_LOC/data_generation/template_extraparams"

INPUT_VCF_FILE="$DATA_LOC/Ebrahimi_3_3_2026_top10_randomized/subsampled_top10_randomized.vcf"  #[insert input path]

"$SCRIPTS_LOC/data_preparation/vcf_summary.sh" \
    $INPUT_VCF_FILE
