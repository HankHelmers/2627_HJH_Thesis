EXP_OUTPUT_PATH=$1
STR_RESULTS_FOLDER=$2
OG_STRUCTURE_FILE=$3
NUM_RUNS=$4
OUTPUT_FILE_NAME=$5
SCRIPTS_LOC=$6


echo "Structure visualize for:"
# echo $EXP_OUTPUT_PATH
# echo $STR_RESULTS_FOLDER
# echo $OG_STRUCTURE_FILE
# echo $NUM_RUNS
# echo $SCRIPTS_LOC

# Example input for this Rscript
# generate_str_plots <- function(exp_output_folder, str_results_folder, original_structure_input_file, number_of_runs) {
Rscript "$SCRIPTS_LOC/data_visualization/visualize_structure.R" \
    "$EXP_OUTPUT_PATH" \
    "$STR_RESULTS_FOLDER" \
    "$OG_STRUCTURE_FILE" \
    "$NUM_RUNS" \
    "$OUTPUT_FILE_NAME"

echo "Structure visualization complete."
