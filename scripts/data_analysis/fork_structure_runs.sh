# ----
# Runs structure with the desired inputs, creates output folder for each result
# 
# Inputs 
#   - #1: FULL data location to .str (in data)
#   - #2: FULL experiment output folder (in experiments_output)
#   - #3: FULL mainparams_template location
#    
#   - #4: NUMINDS
#   - #5: NUMLOCI
#   - #6: LABEL
#   - #7: MISSING
#   - #8: BURNIN
#   - #9: RUNLENGTH - (Called NUMREPS in file)
#   - #10: RUNREPEATS - number of runs to repeat

#!/bin/bash
which structure # verify accessible

# Read basic inputs
INPUT_STR_FILE=$1
EXP_OUTPUT_LOC=$2
MAIN_PARAMS_LOC=$3
EXTRA_PARAMS_LOC=$4

# Experimental inputs 
NUMINDS=$5
NUMLOCI=$6
LABEL=$7
MISSING=$8

BURNIN=$9
RUNLENGTH=${10}
RUNREPEATS=${11}

# ---------------------------------------------
echo "Testing structure inputs"

# Group 1: File Paths & Locations
echo "Files & Folders:"
printf "  %-22s %s\n" "Input STR File:" "$INPUT_STR_FILE"
printf "  %-22s %s\n" "Output Location:" "$EXP_OUTPUT_LOC"
printf "  %-22s %s\n" "Main Params Location:" "$MAIN_PARAMS_LOC"
printf "  %-22s %s\n" "Extra Params Location:" "$EXTRA_PARAMS_LOC"
echo ""

# Group 2: Experimental & Dataset Inputs
echo "Dataset Metrics:"
printf "  %-22s %s\n" "Number of Individuals:" "$NUMINDS"
printf "  %-22s %s\n" "Number of Loci:" "$NUMLOCI"
printf "  %-22s %s\n" "Label Flag:" "$LABEL"
printf "  %-22s %s\n" "Missing Data Value:" "$MISSING"
echo ""

# Group 3: Structure Run Parameters
echo "STR Parameters:"
printf "  %-22s %s\n" "Burn-in Iterations:" "$BURNIN"
printf "  %-22s %s\n" "Run Length:" "$RUNLENGTH"
printf "  %-22s %s\n" "Run Repeats:" "$RUNREPEATS"

# ----------------------------- File management
# Make output directory for structure outputs
date_name=$(date +%Y%m%d_%H%M%S)
mkdir -p "$EXP_OUTPUT_LOC/str_output_$date_name"
OUTFOLDER="$EXP_OUTPUT_LOC/str_output_$date_name"
OUTFILE="$OUTFOLDER/{OUTPUT_FILE_NAME}" # Create OUTFILE location, add {} for dynamic naming below
INFILE=$INPUT_STR_FILE

# create directory for additional parameters
mkdir -p "$OUTFOLDER/str_parameters"
mkdir -p "$OUTFOLDER/logs"
PARAMS_FOLDER="$OUTFOLDER/str_parameters"

# create base params for this experiment
cp "$MAIN_PARAMS_LOC" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"

# create copy of extraparams
cp "$EXTRA_PARAMS_LOC" "$PARAMS_FOLDER/extraparams"

# -----------------------------
# Replace placeholders in-place using sed
# data params
sed -i "s/{NUMINDS}/${NUMINDS}/g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"  # WORKS
sed -i "s/{NUMLOCI}/${NUMLOCI}/g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"
sed -i "s/{LABEL}/${LABEL}/g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"
sed -i "s/{MISSING}/${MISSING}/g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"

# alg params (burn-in and run length)
sed -i "s/{BURNIN}/${BURNIN}/g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"
sed -i "s/{RUNLENGTH}/${RUNLENGTH}/g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"

# files
sed -i "s|{INFILE}|${INFILE}|g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"
sed -i "s|{OUTFILE}|${OUTFILE}|g" "$PARAMS_FOLDER/copy_of_mainparams_exp_template"

pids=()

for i in $(seq 1 "$RUNREPEATS"); do
(
    LOG_FILE="$OUTFOLDER/logs/STR_log_run_$i.txt"
    echo "Run $i starting..."  > $LOG_FILE

    start=$(date +%s)

    # unique parameter file
    main_param_file="$PARAMS_FOLDER/mainparams_run${i}"
    extra_param_file="$PARAMS_FOLDER/extraparams"

    cp "$PARAMS_FOLDER/copy_of_mainparams_exp_template" "$main_param_file"

    # unique output prefix
    sed -i "s|{OUTPUT_FILE_NAME}|run${i}|g" "$main_param_file"

    # run structure
    structure -m "$main_param_file" -e "$extra_param_file" >> $LOG_FILE

    # # move parameter files
    # mv "$main_param_file" "$OUTFOLDER/str_parameters/"    
    # mv *params* "$OUTFOLDER/str_parameters"
    # mv seed.txt "$OUTFOLDER/str_parameters"
    # mv extraparams "$OUTFOLDER/str_parameters"

    # seed file may collide if all runs share cwd
    if [[ -f seed.txt ]]; then
        mv seed.txt "$PARAMS_FOLDER/seed_run${i}.txt"
    fi

    elapsed=$(($(date +%s) - start))
    echo "Run $i completed in ${elapsed}s" >> $LOG_FILE

) &

    pids+=($!)
done

# wait for all background jobs
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All runs complete."