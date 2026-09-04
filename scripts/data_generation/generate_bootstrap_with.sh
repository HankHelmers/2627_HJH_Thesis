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
JC_IDS_list_file="$BOOT_FOLDER/JC_ids.txt"  # List of possible JC ids to subset from
JA_IDS_list_file="$BOOT_FOLDER/JA_ids.txt"  # List of possible JA ids to subset from
loci_ID_file="$BOOT_FOLDER/loci_ids.txt"
all_ID_list_file="$BOOT_FOLDER/combined_JC_JA_ids.txt"
num_JC_inds=$3       # Number of JC to sample
num_JA_inds=$4       # Number of JA to sample
num_F1=$5
num_BC1=$6 
num_BC2=$7
num_loci=$8
RAW_VCF=$9
FINAL_VCF="$BOOT_FOLDER/vcf/boot${BOOT_NUM}_combined_JC_JA.vcf.gz"

echo "=== Input Argument Check ==="
echo "BOOT_FOLDER:        $BOOT_FOLDER"
echo "BOOT_NUM:        $BOOT_NUM"
echo "JC_IDS_list_file:   ${JC_IDS_list_file}"
echo "JA_IDS_list_file:   ${JA_IDS_list_file}"
echo "loci_ID_file:       ${loci_ID_file}"
echo "num_JC_inds:        ${num_JC_inds}"
echo "num_JA_inds:        ${num_JA_inds}"
echo "num_F1:             ${num_F1}"
echo "num_BC1:            ${num_BC1}"
echo "num_BC2:            ${num_BC2}"
echo "num_loci:           ${num_loci}"
echo "RAW_VCF:            ${RAW_VCF}"

# ----------------------------------
# Apply bootstrap to VCF 
# 1. Combine JC and JA into one file to apply subsetting
# 2. Seperate duplicates for indexing
# 3. Apply subsampling with bcftools to both original and duplicate 
# 4. Combine with indexed duplicates 

# Combine together for IDs to subset on
cat "$JC_IDS_list_file" \
    "$JA_IDS_list_file" \
    > $all_ID_list_file

    # Sort and move duplicate sample IDs into a seperate file 
    #   This is needed because bcftools doesn't allow duplicates in sample
sort $all_ID_list_file | uniq -d > "$BOOT_FOLDER/duplicates.txt" 

# Remove duplicates from other file
    # sort -u outputs the duplicate free into a temp file
    # then we override the original with temp!
sort -u "$all_ID_list_file" > temp.txt && mv temp.txt "$all_ID_list_file" 

# In ORIGINAL VCF, apply subsample of random loci and parents 
bcftools view \
    -S $all_ID_list_file  \
    -T $loci_ID_file \
    $RAW_VCF \
    -Oz -o $BOOT_FOLDER/vcf/no_duplicates.vcf.gz
    # -Oz: output, (z-compressed, v-plain text) 

# In DUPLICATE VCF, apply subsample of random loci and parents
bcftools view \
    -S "$BOOT_FOLDER/duplicates.txt"  \
    -T $loci_ID_file \
    $RAW_VCF \
    -Oz -o $BOOT_FOLDER/vcf/duplicates.vcf.gz
    # -Oz: output, (z-compressed, v-plain text) 

# Index both files before merging
bcftools index $BOOT_FOLDER/vcf/no_duplicates.vcf.gz
bcftools index $BOOT_FOLDER/vcf/duplicates.vcf.gz

# Merge duplicates with index
bcftools merge \
    --force-samples \
    -Ov -o $FINAL_VCF \
    $BOOT_FOLDER/vcf/no_duplicates.vcf.gz \
    $BOOT_FOLDER/vcf/duplicates.vcf.gz

# Remove intermediate vcfs
rm $BOOT_FOLDER/vcf/duplicates.vcf.gz
rm $BOOT_FOLDER/vcf/no_duplicates.vcf.gz

# ----------------------------------
# Convert VCF to genepop
"$SCRIPT_LOC/data_generation/bootstrap_to_genepop.sh" \
    $BOOT_FOLDER/genepop \
    $FINAL_VCF

# ----------------------------------
# Generate hybrids 

# -- F1s

# -- BC1s

# -- BC2s 

# ----------------------------------
# Convert hybrid genepop back to VCF 


# ----------------------------------
# Convert VCF to STR 