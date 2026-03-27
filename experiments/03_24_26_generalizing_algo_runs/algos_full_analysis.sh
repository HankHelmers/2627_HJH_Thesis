
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
# Full data path to str data file
DATA_FILE_LOC=$DATA_LOC/Ebrahimi_3_3_2026_download/ebrahimi_3_3_clean.recode.strct_in
MAIN_PARAMS_LOC="$SCRIPTS_LOC/data_generation/template_structure_mainparams.txt"
EXTRA_PARAMS_LOC="$SCRIPTS_LOC/data_generation/template_extraparams"

# Experimental inputs 
NUMINDS=66834       # wc -l ebrahimi_3_3.bim
NUMLOCI=288
LABEL=1
MISSING=-9

BURNIN=5000
RUNLENGTH=1000
RUNREPEATS=5

echo "NUMINDS input: $NUMINDS"
echo "BURNIN input: $BURNIN"

# ---- Experiment
$SCRIPTS_LOC/data_generation/base_structure_run.sh \
    "$EXP_NAME" \
    "$DATA_FILE_LOC" \
    "$EXP_OUTPUT_PATH" \
    "$MAIN_PARAMS_LOC" \
    "$EXTRA_PARAMS_LOC" \
    "$NUMINDS" \
    "$NUMLOCI" \
    "$LABEL" \
    "$MISSING" \
    "$BURNIN" \
    "$RUNLENGTH" \
    "$RUNREPEATS"


# INPUTS 
#   - #1: EXP_NAME, experiment name
#   - #2: FULL data location to .str (in data)
#   - #3: FULL experiment output folder (in experiments_output)
#   - #4: FULL mainparams_template location
#    
#   - #5: NUMINDS
#   - #6: NUMLOCI
#   - #7: LABEL
#   - #8: MISSING
#   - #9: BURNIN
#   - #10: RUNLENGTH - (Called NUMREPS in file)
#   - #11: RUNREPEATS - number of runs to repeat