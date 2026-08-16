
# ----------------------------- Configurations
BASE_DIR="$(pwd)"            
DATA_LOC="$BASE_DIR/../data"

EXP_ID=1

EXP_DATASET="$DATA_LOC/all_experiments_08_15.csv"
RAW_DATASET="$DATA_LOC/raw_input_data_08_15.csv"
EXP_FOLDER="$DATA_LOC/generated_input/experiment_${EXP_ID}"

mkdir -p "$EXP_FOLDER"

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
        vary_JC_pop vary_JA_pop num_loci vary_loci description purpose question <<< "$EXP_ROW"

echo "Loaded Experiment $EXP_ID -> Dataset ID: $dataset_id"

# -----------------
# 3. Retrieve dataset file from dataset_id
RAW_DATASET_ROW=$(awk -F',' -v id="$dataset_id" '$1 == id {print $0; exit}' "$RAW_DATASET")

if [[ -z "$EXP_ROW" ]]; then
    echo "Error: Dataset ID $dataset_id not found in $RAW_DATASET_ROW" >&2
    exit 1
fi

IFS=',' read -r dataset_id data_folder_name primary_input_file \
                    owner_sharer num_ids num_loci description <<< "$RAW_DATASET_ROW"

DATASET_LOC="$DATA_LOC/$data_folder_name/$primary_input_file"

echo "Loaded dataset for experiment $EXP_ID --> $DATASET_LOC"

# -----------------
# 4. Generate bootstraps 

echo "Load Experiment 1 Data -- Generating $num_bootstraps bootstraps..."

# For i in ${num_bootstraps} 
#   1. Create folder in experiment folder for bootstrap i
#        
#       generate_bootstraps_with(raw_data_file_loc, num_JC_inds, num_JA_inds, num_F1, num_BC1, num_BC2, vary_JC_pop, vary_JA_pop, num_loci, vary_loci)
#   
#

echo "Bootstraps complete"