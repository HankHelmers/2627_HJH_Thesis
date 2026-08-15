#
# General version of NEWHYBRIDS RUN
# with visualization. Accepts multiple 
# NH files to run one after each other.
#

# Example start file to paste: 
# ----------------------------- Default for all experiments
# BASE_DIR="$(pwd)"            # Base directory (where script is run from)
# SCRIPTS_LOC="$BASE_DIR/../../scripts"
# DATA_LOC="$BASE_DIR/../../data"
# OUTPUT_ROOT="$BASE_DIR/../../experiment_outputs"

# # Experiment naming
# EXP_NAME="$(basename "$BASE_DIR")"
# EXP_OUTPUT_NAME="output_$EXP_NAME"
# EXP_OUTPUT_PATH="$OUTPUT_ROOT/$EXP_OUTPUT_NAME"

# # Create output directory (if needed)
# mkdir -p "$EXP_OUTPUT_PATH"

# # 1: List of NH files to run through, ex: (pull paths: 200 400 600 1000)  
# # 2: Burnin
# # 3: Run length
# # 4. Run repeats

# # Note num of individuals & loci:
# #  - NUM INDS: 20
# #  - NUM LOCI: 200 to 1000

# # Contains a folder of only .nh files 
# NH_DATA_FOLDER="$DATA_LOC/Sample_Population_Data/NewHybrids"
# GENOTYPE_LOC="$SCRIPTS_LOC/data_generation/genotype_cat_f1"
# BURNIN=500000
# RUNLENGTH=100000
# NUMREPEATS=1

# "$SCRIPTS_LOC/data_generation/nh_analysis_mult_files.sh" \
#     $NH_DATA_FOLDER \
#     $BURNIN \
#     $RUNLENGTH \
#     $NUMREPEATS \
#     $GENOTYPE_LOC \
#     $EXP_NAME \
#     $EXP_OUTPUT_PATH

# ----------------------------- INPUTS

# NEWHYBRIDS
BASE_DIR="$(pwd)"
SCRIPTS_LOC="$BASE_DIR/../../scripts"
NH_INPUT_FOLDER=$1 # 

# Experimental inputs 
LABEL=1
MISSING=-9

BURNIN=$2
RUNLENGTH=$3
RUNREPEATS=$4
GENOTYPE_LOC=$5

# Need this to write the output files into the correct output location
EXP_NAME=$6
EXP_OUTPUT_PATH=$7


# Collect all the input files from the designated folder
INPUT_NH_FILES=( "$NH_INPUT_FOLDER"/*.nh )

for i in "${INPUT_NH_FILES[@]}"; do
    # echo $i
    
    # NEWHYBRIDS
    $SCRIPTS_LOC/data_generation/fork_nh_runs.sh \
        "$EXP_NAME" \
        "$i" \
        "$EXP_OUTPUT_PATH" \
        "$GENOTYPE_LOC" \
        "$BURNIN" \
        "$RUNLENGTH" \
        "$RUNREPEATS" \
        > /dev/null 2>&1 &
        # Supress output
    wait 
done

# Get NH output
ls -d "$EXP_OUTPUT_PATH"/newhybrids* >> $EXP_OUTPUT_PATH/nh_folders.txt

NUM_FOLDERS=${#INPUT_NH_FILES[@]}

# Loop for each output folder and generate the NH output
for i in $(seq 1 $NUM_FOLDERS); do 
    CURR_FOLDER=$(sed -n "$i"p $EXP_OUTPUT_PATH/nh_folders.txt)

    echo $CURR_FOLDER >> "$EXP_OUTPUT_PATH/nh_imaging_log.txt"

    Rscript "$SCRIPTS_LOC/data_visualization/visualize_nh_ggplot.R" \
        "$RUNREPEATS" \
        "$CURR_FOLDER" \
        "$CURR_FOLDER" >> "$EXP_OUTPUT_PATH/nh_imaging_log.txt"
done
exit 0