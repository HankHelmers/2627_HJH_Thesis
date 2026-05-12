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

DATA_FOLDER="$DATA_LOC/Ebrahimi_3_3_2026_subsets"

SUBSAMPLED_LIST=("3_subsampled_top10_loci10" "3_subsampled_top10_loci200" "4_all_loci_randomized_subsample_top10" "5_200_loci_randomized_subsample_top10")

python "$SCRIPTS_LOC/data_generation/recom-sim.py" \
    "$DATA_FOLDER/genepop/3_subsampled_top10_loci10.gen" \
    1 \
    --num-offs 10 \
    --out "$DATA_FOLDER/genepop/3_subsampled_top10_loci10_f1s.gen"