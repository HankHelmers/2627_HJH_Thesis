
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

# Create output folder
mkdir -p "$EXP_OUTPUT_FILE/newhybrids"
NH_OUTPUT_FOLDER="$EXP_OUTPUT_FILE/newhybrids"

for i in $(seq 1 "$RUNREPEATS"); do  
    newhybrids -d ${DATA_FILE_LOC} -c ${GENOTYPE_LOC} --burn-in ${BURNIN} --num-sweeps ${NUMREPS} --no-gui > NewHybridsLog.txt
    wait

    # move files to own directory in output 
    mkdir ${NH_OUTPUT_FOLDER}/run${i}
    mv aa* EchoedGtypData.txt NewHybridsLog.txt ${NH_OUTPUT_FOLDER}/run${i}
done 


