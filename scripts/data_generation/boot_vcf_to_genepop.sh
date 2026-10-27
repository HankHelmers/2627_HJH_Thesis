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
FINAL_VCF="$BOOT_FOLDER/vcf/boot${BOOT_NUM}_combined_JC_JA.vcf.gz"
FINAL_GENEPOP="$BOOT_FOLDER/genepop/$(basename $FINAL_VCF .vcf.gz).gen"

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
echo "FINAL_VCF:           $FINAL_VCF"
echo "FINAL_GENEPOP:       $FINAL_GENEPOP"
echo "num_JC_inds:         $num_JC_inds"
echo "num_JA_inds:         $num_JA_inds"
echo "num_gens:            $num_gens"
echo "num_hybrids_per_gen: $num_hybrids_per_gen"
echo "num_loci:            $num_loci"
echo "RAW_VCF:             $RAW_VCF"

# ----------------------------------
# Convert VCF to genepop
Rscript "$SCRIPT_LOC/data_conversion/vcf_to_genepop.R" \
        $FINAL_VCF \
        $FINAL_GENEPOP

# Programmatically add "Pop" above the JC and JA populations
#  - Keep the first twp lines the same
{
  head -n 2 "$FINAL_GENEPOP"
  tail -n +3 "$FINAL_GENEPOP" | sort -t'_' -k2,2 | awk '{
      if (!seen && $0 ~ /_JC/) {
          print "POP"
          seen = 1
      }
      print
  }'
} > "$BOOT_FOLDER/genepop/sorted.gen"

# Replace the final genepop with the sorted
mv "$BOOT_FOLDER/genepop/sorted.gen" "$FINAL_GENEPOP"

echo "VCF to Genepop complete."