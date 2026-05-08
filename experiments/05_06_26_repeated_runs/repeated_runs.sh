

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

# Basically I want to be able to run the full algos on several different datasets, so the full algos run needs to be specialized enough that I can change the name of the output folder within the experiment folder 
