
# ----
# Running the algorithms with generalized inputs
# 
# - Default location parameters
# - Generate output folder 

# INPUTS 
#   - #1: EXP_NAME, experiment name
#   - #2: FULL data location to .nh (in data)
#   - #3: FULL experiment output folder (in experiments_output)
#   - #4: Genotype file location 

#   - #5: BURNIN
#   - #6: RUNLENGTH - (Called NUMREPS in file)
#   - #7: RUNREPEATS - number of runs to repeat


# file parameters
EXP_NAME=$1
DATA_FILE_LOC=$2
EXP_OUTPUT_FILE=$3
GENOTYPE_LOC=$4

# alg params
BURNIN=$5
NUMREPS=$6  # run length
RUNREPEATS=$7

# Create output folder using
date_name=$(date +%Y%m%d)
INPUT_NH_FILE_NAME=$(basename "$DATA_FILE_LOC" .nh)

NH_OUTPUT_FOLDER="$EXP_OUTPUT_FILE/newhybrids_"$INPUT_NH_FILE_NAME"_$date_name"

mkdir -p "$NH_OUTPUT_FOLDER"

LOG_FILE="$NH_OUTPUT_FOLDER/NH_log.txt"

echo "Starting $RUNREPEATS NH runs at $date_name..." >> $LOG_FILE

# Run NH for each requested repeat
pids=()

for i in $(seq 1 "$RUNREPEATS"); do
(
    echo "NH Run $i..." >> $LOG_FILE

    start=$(date +%s)
    echo "start: $start" >> $LOG_FILE

    # need to create a seperate directly to run newhybrids from
    # otherwise the output files would override each other
    mkdir -p "run$i"
    cd "run$i"

    newhybrids \
        -d ${DATA_FILE_LOC} \
        -c ${GENOTYPE_LOC} \
        --burn-in ${BURNIN} \
        --num-sweeps ${NUMREPS} \
        --no-gui > $NH_OUTPUT_FOLDER/NewHybridsLog_Run$i.txt

    elapsed=$(($(date +%s) - $start))
    echo "$elapsed seconds elapsed" >> "$LOG_FILE"

    # move files to own directory in output 
    cd ..
    mv run$i $NH_OUTPUT_FOLDER
) &
    pids+=($!)
done 

# wait for all background jobs to find
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All runs complete." >> $LOG_FILE

