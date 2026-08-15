# ----
# Runs structure with the desired inputs, creates output folder for each result
# 
# Inputs 
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

#!/bin/bash
which structure # verify accessible

# Read basic inputs
EXP_NAME=$1
DATA_LOC=$2
EXP_OUTPUT_LOC=$3
MAIN_PARAMS_LOC=$4
EXTRA_PARAMS_LOC=$5

# Experimental inputs 
NUMINDS=$6
NUMLOCI=$7
LABEL=$8
MISSING=$9
BURNIN=${10}
RUNLENGTH=${11}
RUNREPEATS=${12}

# ----------------------------- File management
# Make output directory for structure outputs
date_name=$(date +%Y%m%d_%H%M%S)
mkdir -p "$EXP_OUTPUT_LOC/structure_$date_name"
OUTFOLDER="$EXP_OUTPUT_LOC/structure_$date_name"
OUTFILE="$OUTFOLDER/{OUTPUT_FILE_NAME}" # Create OUTFILE location, add {} for dynamic naming
INFILE=$DATA_LOC


# create base params for this experiment
cp "$MAIN_PARAMS_LOC" "copy_of_mainparams_exp_template"

# create copy of extraparams
cp "$EXTRA_PARAMS_LOC" "extraparams"

# -----------------------------
# Replace placeholders in-place using sed
# data params
sed -i "s/{NUMINDS}/${NUMINDS}/g" copy_of_mainparams_exp_template  # WORKS
sed -i "s/{NUMLOCI}/${NUMLOCI}/g" copy_of_mainparams_exp_template
sed -i "s/{LABEL}/${LABEL}/g" copy_of_mainparams_exp_template
sed -i "s/{MISSING}/${MISSING}/g" copy_of_mainparams_exp_template

# # alg params (burn-in and run length)
sed -i "s/{BURNIN}/${BURNIN}/g" copy_of_mainparams_exp_template
sed -i "s/{RUNLENGTH}/${RUNLENGTH}/g" copy_of_mainparams_exp_template

# files
sed -i "s|{INFILE}|${INFILE}|g" copy_of_mainparams_exp_template
sed -i "s|{OUTFILE}|${OUTFILE}|g" copy_of_mainparams_exp_template

# create directory for additional parameters
mkdir -p "$OUTFOLDER/str_parameters"
mkdir -p "$OUTFOLDER/logs"

pids=()

for i in $(seq 1 "$RUNREPEATS"); do
(
    LOG_FILE="$OUTFOLDER/logs/STR_log_run_$i.txt"
    echo "Run $i starting..."  > $LOG_FILE

    start=$(date +%s)

    # unique parameter file
    param_file="mainparams_run${i}"

    cp copy_of_mainparams_exp_template "$param_file"

    # unique output prefix
    sed -i "s|{OUTPUT_FILE_NAME}|run${i}|g" "$param_file"

    # run structure
    structure -m "$param_file" -e extraparams

    # move parameter files
    mv "$param_file" "$OUTFOLDER/str_parameters/"    
    mv *params* "$OUTFOLDER/str_parameters"
    mv seed.txt "$OUTFOLDER/str_parameters"
    mv extraparams "$OUTFOLDER/str_parameters"

    # seed file may collide if all runs share cwd
    # if [[ -f seed.txt ]]; then
    #     mv seed.txt "$OUTFOLDER/str_parameters/seed_run${i}.txt"
    # fi

    elapsed=$(($(date +%s) - start))
    echo "Run $i completed in ${elapsed}s" > $LOG_FILE

) &

    pids+=($!)
done

# wait for all background jobs
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All runs complete."