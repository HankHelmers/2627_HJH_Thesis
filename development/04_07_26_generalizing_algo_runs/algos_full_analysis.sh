
# ----
# Running the algorithms with generalized inputs
# 
# - Default location parameters
# - Generate output folder 

# ----------------------------- Default for all experiments
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# Experiment naming
EXP_NAME="$(basename "$BASE_DIR")"
EXP_OUTPUT_NAME="output_$EXP_NAME"
EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT_NAME"

# Create output directory (if needed)
mkdir -p "$EXP_OUTPUT_PATH"

# ----------------------------- INPUTS
# STRUCTURE
STR_DATA_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_prepared/subsampled_pure_jc_ja.str.str"
MAIN_PARAMS_LOC="$SCRIPTS_LOC/data_generation/template_structure_mainparams.txt"
EXTRA_PARAMS_LOC="$SCRIPTS_LOC/data_generation/template_extraparams"

# NEWHYBRIDS
NH_DATA_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_prepared/subsampled_pure_jc_ja.nh"
GENOTYPE_LOC="$SCRIPTS_LOC/data_generation/genotype_cat_f1"

# Experimental inputs 
NUMINDS=50       # wc -l ebrahimi_3_3.bim
NUMLOCI=100
LABEL=1
MISSING=-9

BURNIN=5000
RUNLENGTH=1000
RUNREPEATS=5

# echo "NUMINDS input: $NUMINDS"
# echo "BURNIN input: $BURNIN"

# ---- Experiment
# STRUCTURE 
# $SCRIPTS_LOC/data_generation/base_structure_run.sh \
#     "$EXP_NAME" \
#     "$STR_DATA_FILE_LOC" \
#     "$EXP_OUTPUT_PATH" \
#     "$MAIN_PARAMS_LOC" \
#     "$EXTRA_PARAMS_LOC" \
#     "$NUMINDS" \
#     "$NUMLOCI" \
#     "$LABEL" \
#     "$MISSING" \
#     "$BURNIN" \
#     "$RUNLENGTH" \
#     "$RUNREPEATS" \
#     > /dev/null 2>&1 &
#     # Supress output

# NEWHYBRIDS
$SCRIPTS_LOC/data_generation/base_newhybrids_run.sh \
    "$EXP_NAME" \
    "$NH_DATA_FILE_LOC" \
    "$EXP_OUTPUT_PATH" \
    "$GENOTYPE_LOC" \
    "$BURNIN" \
    "$RUNLENGTH" \
    "$RUNREPEATS"
    > /dev/null 2>&1 &
    # Supress output