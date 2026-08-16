# ----
# Template for experiment scripts
# 
# - Default location parameters
# - Generate output folder 


# ---- Default for all experiments 
BASE_DIR="$(pwd)"            # Base directory (where script is run from)
SCRIPTS_LOC="$BASE_DIR/../../scripts"
DATA_LOC="$BASE_DIR/../../data"
OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# Experiment naming
EXP_NAME="$(basename "$BASE_DIR")"
EXP_OUTPUT="output_$EXP_NAME"
EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT"

# Create output directory (if needed)
mkdir -p "$EXP_OUTPUT_PATH"

# ---- Experiment