# Generate a single bootstrap with the 
# - BOOT_FOLDER
# - INPUT_VCF
# - LIST_OF_LOCI_IDS
# - LIST_OF_INDS

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
HYBRID_GENEPOP="$BOOT_FOLDER/genepop/all_generations_hybrids.gen"

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
echo "HYBRID_GENEPOP:     $HYBRID_GENEPOP"
echo "num_JC_inds:         $num_JC_inds"
echo "num_JA_inds:         $num_JA_inds"
echo "num_gens:            $num_gens"
echo "num_hybrids_per_gen: $num_hybrids_per_gen"
echo "num_loci:            $num_loci"
echo "RAW_VCF:             $RAW_VCF"


# ----------------------------------
# Convert hybrid genepop back to VCF 
echo "================================="
echo "Converting hybrid genepop to VCF"

Rscript "$SCRIPT_LOC/data_conversion/genepop_to_vcf.R" \
    $HYBRID_GENEPOP \
    $BOOT_FOLDER/vcf/ \
    "with_hybrids" 
# gzip "$BOOT_FOLDER/vcf/with_hybrids.vcf" 

# ----------------------------------
# Convert VCF to STR 
echo "================================="
echo "Converting hybrid VCF to STR"
"$SCRIPT_LOC/data_conversion/vcf_to_structure.sh" \
    "$BOOT_FOLDER/vcf/with_hybrids.vcf.gz" \
    "$BOOT_FOLDER/str/with_hybrids.str"
   
