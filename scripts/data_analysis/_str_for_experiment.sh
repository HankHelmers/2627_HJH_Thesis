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
LOG_FILE="$EXP_FOLDER/str_log.txt"

# reset log if needed
echo "" > $LOG_FILE

# ----------------------------- Get inputs 
echo "Loading... Experiment $EXP_ID -> Dataset ID: $dataset_id" >> "$LOG_FILE"

# -----------------
# 1. With EXP_ID retrieve relevant experiment data 
EXP_ROW=$(awk -F',' -v id="$EXP_ID" '$1 == id {print $0; exit}' "$EXP_DATASET")

if [[ -z "$EXP_ROW" ]]; then
    echo "Error: Experiment ID $EXP_ID not found in $EXP_DATASET" >> "$LOG_FILE" 2>&1
    exit 1
fi

# -----------------
# 2. Parse CSV fields into variables 
IFS=',' read -r experiment_id dataset_id num_bootstraps num_JC_inds num_JA_inds num_F1 num_BC1 num_BC2 \
        vary_JC_pop vary_JA_pop num_loci vary_loci str_burnin str_runlength str_runrepeats description purpose question <<< "$EXP_ROW"

# 3. Clean inputs 
TOTAL_NUM_INDS=$(( num_JC_inds * 8 ))

echo "Loaded Experiment $EXP_ID -> Dataset ID: $dataset_id" >> "$LOG_FILE"

# -----------------------------
echo "Beginning bootstraps sequencially." >> "$LOG_FILE"

# Run STRUCTURE on bootstraps in batches of 5
batch_size=2

for ((batch_start=1; batch_start<=num_bootstraps; batch_start+=batch_size)); do

    echo "Starting bootstrap batch: $batch_start-$((batch_start + batch_size - 1))" >> "$LOG_FILE"

    # Start up to 5 bootstrap jobs
    for ((boot_num=batch_start; boot_num<=batch_start + batch_size - 1 && boot_num<=num_bootstraps; boot_num++)); do
        (
            echo "Starting boot $boot_num" >> "$LOG_FILE"
            start=$(date +%s%3N)

            CURR_BOOT_FOLDER="$EXP_FOLDER/boot$boot_num"
            EXP_OUTPUT_FOLDER="$CURR_BOOT_FOLDER/str_outputs"

            mkdir -p "$EXP_OUTPUT_FOLDER"

            str_files=("$CURR_BOOT_FOLDER/str/"*)
            INPUT_STR_FILE="$CURR_BOOT_FOLDER/str/$(basename "${str_files[0]}")"

            # STR run
            "$SCRIPT_LOC/data_analysis/fork_structure_runs.sh" \
                "$INPUT_STR_FILE" \
                "$EXP_OUTPUT_FOLDER" \
                "$MAIN_PARAMS_LOC" \
                "$EXTRA_PARAMS_LOC" \
                "$TOTAL_NUM_INDS" \
                "$num_loci" \
                "$LABEL" \
                "$MISSING" \
                "$str_burnin" \
                "$str_runlength" \
                "$str_runrepeats"

            elapsed=$(($(date +%s%3N) - start))
            minutes=$((elapsed / 60000))
            seconds=$(((elapsed % 60000) / 1000))

            echo "Run STRUCTURE on boot $boot_num completed in ${minutes} min ${seconds} sec" >> "$LOG_FILE"

        ) &

    done

    # Wait for all jobs in this batch to finish
    wait

    echo "Bootstrap batch completed: $batch_start-$((batch_start + batch_size - 1))" >> "$LOG_FILE"

done

echo "All bootstraps complete." >> "$LOG_FILE"