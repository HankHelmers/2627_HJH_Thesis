# Given a number of hybrids and a VCF
# convert to genepop and loop
# to create X generations of hybrids 

# ----------------------------- Configurations
BASE_DIR="/work/williarj/williarj/2627_HJH_Thesis/"            
DATA_LOC="$BASE_DIR/data"
RAW_DATA_LOC="$DATA_LOC/raw_input"
SCRIPT_LOC="$BASE_DIR/scripts"

BOOTSTRAP_LOC_FILE="$DATA_LOC/all_bootstrap_locations.csv" # File where bootstrap file locations are saved

# Get the input files 
BOOT_FOLDER=$1
BOOT_NUM=$2        # Which bootstrap are we on
selection_proc=$3

JC_IDS_list_file="$BOOT_FOLDER/JC_ids.txt"  # List of possible JC ids to subset from
JA_IDS_list_file="$BOOT_FOLDER/JA_ids.txt"  # List of possible JA ids to subset from
loci_ID_file="$BOOT_FOLDER/loci_ids.txt"
all_ID_list_file="$BOOT_FOLDER/combined_JC_JA_ids.txt"
FINAL_VCF="$BOOT_FOLDER/vcf/boot${BOOT_NUM}_combined_JC_JA.vcf.gz"
OG_PARENT_INPUT="$BOOT_FOLDER/genepop/$(basename $FINAL_VCF .vcf.gz).gen"

num_JC_inds=$4       # Number of JC to sample
num_JA_inds=$5       # Number of JA to sample
num_gens=$6
num_hybrids_per_gen=$7
num_loci=$8
RAW_VCF=$9

echo "=== Input Argument Check ==="
echo "BOOT_FOLDER:         $BOOT_FOLDER"
echo "BOOT_NUM:            $BOOT_NUM"
echo "selection_proc:      $selection_proc"
echo "JC_IDS_list_file:    $JC_IDS_list_file"
echo "JA_IDS_list_file:    $JA_IDS_list_file"
echo "loci_ID_file:        $loci_ID_file"
echo "all_ID_list_file:    $all_ID_list_file"
echo "FINAL_VCF:           $FINAL_VCF"
echo "OG_PARENT_INPUT:       $OG_PARENT_INPUT"
echo "num_JC_inds:         $num_JC_inds"
echo "num_JA_inds:         $num_JA_inds"
echo "num_gens:            $num_gens"
echo "num_hybrids_per_gen: $num_hybrids_per_gen"
echo "num_loci:            $num_loci"
echo "RAW_VCF:             $RAW_VCF"


if [ "$num_gens" -eq 0 ]; then
    echo "No generations of hybrids specified (num_gens is 0). Exiting script."
    exit 0
fi

# Temp directory
mkdir -p "$BOOT_FOLDER/tmp"

# Create accumulator and add first input
ALL_HYBRIDS_FILE="$BOOT_FOLDER/genepop/all_generations_hybrids.gen"
cp $OG_PARENT_INPUT $ALL_HYBRIDS_FILE

# 1. Generate first gen hybrids as base 
GEN1_RAW="$BOOT_FOLDER/genepop/gen_1_raw.gen"
GEN1_OUT="$BOOT_FOLDER/genepop/gen_1_hybrids.gen"

# Generate F1s
python3 "$SCRIPT_LOC/data_generation/recom-sim.py" \
    "$OG_PARENT_INPUT" \
    1 \
    --num-off "$num_hybrids_per_gen" \
    --out "$GEN1_RAW" > /dev/null

# Keep header, Remove the JA pop
awk -v IGNORECASE=1 '
    BEGIN { in_header = 1 }

    # When the first POP block is hit, turn off the header tracking
    /^POP/ { 
        in_header = 0
        pending_pop = $0
        next 
    }

    # Pass all unknown header and loci lines directly through
    in_header { print; next }

    # Process individual lines after the header section
    /,/ {
        if ($0 ~ /_JA/) { next }
        
        # Flush the stored POP header if this block has valid data
        if (pending_pop != "") {
            print pending_pop
            pending_pop = ""
        }
        print
    }
' "$GEN1_RAW" > "$GEN1_OUT"
rm $GEN1_RAW

# 2. Loop through subsequent advanced backcrosses / generations
# If user asked for more than 1 generation, start iterative crossing
if [ "$num_gens" -gt 1 ]; then
    for (( gen=2; gen<=num_gens; gen++ )); do
        prev_gen=$(( gen - 1 ))
        echo "================================="
        echo "Generating generation $gen (BC$((gen-1))) of hybrids using parents from Gen $prev_gen..."

        # Input previous generation file
        # of the form: POP
        #              IND81_JC ...
        #              POP
        #              F1HYB_090 ...

        # Define temporary workspace files for current loop iteration
        PREV_GEN_FILE="$BOOT_FOLDER/genepop/gen_${prev_gen}_hybrids.gen"  # previous generation of generated hybrids
        CURRENT_GEN_RAW="$BOOT_FOLDER/tmp/gen_${gen}_raw.gen"
        CURRENT_GEN_FINAL="$BOOT_FOLDER/genepop/gen_${gen}_hybrids.gen"   # post processed
        PARENT_POOL_GENEPOP="$BOOT_FOLDER/tmp/parent_pool_gen_${gen}.gen" # current hybrd generation pool

        # ----------------------------------------------------------------------
        # Parsing Step: Construct specialized Parent Genepop file for cross
        # ----------------------------------------------------------------------
        # Extract Genepop file structural metadata (Header line + Loci declarations)
        # Note: In standard Genepop formats, everything up to the first 'Pop' line is structural metadata

        # Generates new hybrid individual pool from synthesized parent populations
        python3 "$SCRIPT_LOC/data_generation/recom-sim.py" \
            "$PREV_GEN_FILE" \
            1 \
            --num-off "$num_hybrids_per_gen" \
            --out "$CURRENT_GEN_RAW" > /dev/null

        # Rename into descriptive Backcross IDs
        Rscript $SCRIPT_LOC/data_generation/rename_generated_hybrid_by_backcross.R \
            "$CURRENT_GEN_RAW" \
            "$CURRENT_GEN_FINAL" \
            "$gen"

        # Add new hybrids to total genepop
        Rscript $SCRIPT_LOC/data_generation/append_hybrids_to_final.R.R \
            "$ALL_HYBRIDS" \
            "$CURRENT_GEN_FINAL" 
    done
fi



## Clean up structural temporary workspace layout directories
## rm -rf "$BOOT_FOLDER/tmp"

echo "All backcrossed populations output compiled to: $ALL_HYBRIDS_FILE"
echo "================================="
