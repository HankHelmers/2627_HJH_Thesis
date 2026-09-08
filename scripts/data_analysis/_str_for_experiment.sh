# -----------------------------
# Takes an experiment folder as input
# then loops through each bootstrap folder 
# in that experiment and runs STR
# on the STR file in /bootX/str/
# -----------------------------

# ----------------------------- Configurations
BASE_DIR="/work/williarj/williarj/2627_HJH_Thesis"            
DATA_LOC="$BASE_DIR/data"
RAW_DATA_LOC="$DATA_LOC/raw_input"
SCRIPT_LOC="$BASE_DIR/scripts"

# Inputs
EXP_ID=$1
EXP_FOLDER="$DATA_LOC/generated_input/experiment_${EXP_ID}"
EXP_DATASET="$DATA_LOC/all_experiments_09_08.csv"
RAW_DATASET="$DATA_LOC/raw_input_data_08_15.csv"

MAIN_PARAMS_LOC="$SCRIPT_LOC/data_analysis/template_structure_mainparams.txt"
EXTRA_PARAMS_LOC="$SCRIPT_LOC/data_analysis/template_extraparams"

LABEL=1
MISSING=-9
echo $EXP_FOLDER

# ----------------------------- Get inputs 
echo "Loading... Experiment $EXP_ID -> Dataset ID: $dataset_id"

# -----------------
# 1. With EXP_ID retrieve relevant experiment data 
#        Reads: Seperate columns in EXP_DATASET with a comma. Column 1 ($1), Column 2 ($2), 
#               and so forth. 
#               
#               Using the interval variable 'id', if column 1's ($1) value is equal to this
#               id, return this entire row to variable.
EXP_ROW=$(awk -F',' -v id="$EXP_ID" '$1 == id {print $0; exit}' "$EXP_DATASET")

if [[ -z "$EXP_ROW" ]]; then
    echo "Error: Experiment ID $EXP_ID not found in $EXP_DATASET" >&2
    exit 1
fi

# -----------------
# 2. Parse CSV fields into variables 
# Set internal delimitor character to ','; then read will seperate by ','
IFS=',' read -r experiment_id dataset_id num_bootstraps num_JC_inds num_JA_inds num_F1 num_BC1 num_BC2 \
        vary_JC_pop vary_JA_pop num_loci vary_loci str_burnin str_runlength str_runrepeats description purpose question <<< "$EXP_ROW"

# 3. Clean inputs 
TOTAL_NUM_INDS=$(( num_JC_inds * 8 ))

echo "Loaded Experiment $EXP_ID -> Dataset ID: $dataset_id"

# -----------------------------
# Get the folders in the EXP_Folder

# For each bootstrap folder in EXP_FOLDER, run structure 
boot_num=1
CURR_BOOT_FOLDER=$EXP_FOLDER/boot$boot_num

EXP_OUTPUT_FOLDER="$CURR_BOOT_FOLDER/str_outputs"
mkdir -p $EXP_OUTPUT_FOLDER

# For each bootstrap folder in EXP_FOLDER, run structure 
    # Get file in $EXP_FOLDER/boot$boot_num/str/
str_files=("$CURR_BOOT_FOLDER/str/"*)
INPUT_STR_FILE="$CURR_BOOT_FOLDER/str/$(basename "${str_files[0]}")" # Theoretically only one str in here

# echo "Running structure runs for boot $boot_num"

# # Group 1: System File Paths
# echo "Files & Folders:"
# printf "  %-22s %s\n" "Input Str File:" "$INPUT_STR_FILE"
# printf "  %-22s %s\n" "Output Folder:" "$EXP_OUTPUT_FOLDER"
# printf "  %-22s %s\n" "Main Params Path:" "$MAIN_PARAMS_LOC"
# printf "  %-22s %s\n" "Extra Params Path:" "$EXTRA_PARAMS_LOC"
# echo ""

# # Group 2: Data Dimensions
# echo "Dataset Metrics:"
# printf "  %-22s %s\n" "Total Individuals:" "$TOTAL_NUM_INDS"
# printf "  %-22s %s\n" "Loci each:" "$num_loci" # num in the exp
# echo ""

# # Group 3: Runtime/Algorithm Variables
# echo "STR Parameters:"
# printf "  %-22s %s\n" "Burn-in Iterations:" "$str_burnin"
# printf "  %-22s %s\n" "Run Length:" "$str_runlength"
# printf "  %-22s %s\n" "Run Repeats:" "$str_runrepeats"

    # STR run 
"$SCRIPT_LOC/data_analysis/fork_structure_runs.sh" \
    $INPUT_STR_FILE \
    $EXP_OUTPUT_FOLDER \
    $MAIN_PARAMS_LOC \
    $EXTRA_PARAMS_LOC \
    $TOTAL_NUM_INDS \
    $num_loci \
    $LABEL \
    $MISSING \
    $str_burnin \
    $str_runlength \
    $str_runrepeats

    # Add output to a new CSV
    # probably easiest as a Rscript to be honest
    # parseStrOut(pathToStructureOutput, outputPath)
        # will have to loop through all of the outputs in all the folders 
        # and runs in those folders