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
echo "all_ID_list_file:    $all_ID_list_file"
echo "FINAL_VCF:           $FINAL_VCF"
echo "FINAL_GENEPOP:       $FINAL_GENEPOP"
echo "num_JC_inds:         $num_JC_inds"
echo "num_JA_inds:         $num_JA_inds"
echo "num_gens:            $num_gens"
echo "num_hybrids_per_gen: $num_hybrids_per_gen"
echo "num_loci:            $num_loci"
echo "RAW_VCF:             $RAW_VCF"


# 1. Combine raw bootstrapped IDs (which contain arbitrary duplicates)
cat "$JC_IDS_list_file" "$JA_IDS_list_file" > "$BOOT_FOLDER/raw_combined_ids.txt"

# 2. Use AWK to dynamically split duplicates into sequential layers.
# This assigns the 1st instance of an ID to layer 0, the 2nd instance to layer 1, etc.
# It outputs unique lists named: layer_0.txt, layer_1.txt, layer_2.txt...
awk '
{
    count[$1]++;
    layer = count[$1] - 1;
    print $0 > ("'"$BOOT_FOLDER"'/layer_" layer ".txt");
}' "$BOOT_FOLDER/raw_combined_ids.txt"


# 3. Gather all generated layers and subset individual VCFs
# We use an array to track files that will be passed to bcftools merge
vcf_merge_list=()

for layer_file in "$BOOT_FOLDER"/layer_*.txt; do
    # Extract layer number from filename
    layer_num=$(basename "$layer_file" | sed 's/[^0-9]//g')
    layer_vcf="$BOOT_FOLDER/vcf/layer_${layer_num}.vcf.gz"
    
    # Subset raw VCF for this specific unique layer
    bcftools view \
        -S "$layer_file" \
        -T "$loci_ID_file" \
        "$RAW_VCF" \
        -Oz -o "$layer_vcf"
        
    # Index the subsetted VCF immediately (required for merging)
    bcftools index "$layer_vcf"
    
    # Append the vcf path to our merge array
    vcf_merge_list+=("$layer_vcf")
done

# 4. Merge all layers back together to build the true duplicate-inflated VCF
# --force-samples automatically appends suffixes (e.g., ID-1, ID-2) to duplicates
bcftools merge \
    --force-samples \
    -Oz -o "$FINAL_VCF" \
    "${vcf_merge_list[@]}"

bcftools index "$FINAL_VCF"

echo "Verify number of individuals subset:"
bcftools query -l "$FINAL_VCF" | wc -l

# 5. Cleanup intermediate layer files safely
rm -f "$BOOT_FOLDER"/layer_*.txt
rm -f "$BOOT_FOLDER"/vcf/layer_*.vcf.gz
rm -f "$BOOT_FOLDER"/vcf/layer_*.vcf.gz.csi
rm -f "$BOOT_FOLDER/raw_combined_ids.txt"


# Not needed for now
# # ==============================================================================
# # SECTION 5: TRACK SUBGROUPS (JC & JA individually) FROM INFLATED VCF
# # ==============================================================================

# # Query the final merged VCF to see the exact sample names (including suffixes)
# bcftools query -l "$FINAL_VCF" > "$BOOT_FOLDER/final_vcf_samples.txt"

# # Clear out the old configuration list files to overwrite them cleanly
# > "$JC_IDS_list_file"
# > "$JA_IDS_list_file"

# # Match suffixes back to their original target populations
# # This parses out the bcftools modified sample names and assigns them correctly
# while read -r full_sample_id; do
#     # Remove any trailing bcftools suffixes (e.g., "SampleA-1" or "SampleA-2" becomes "SampleA")
#     base_id=$(echo "$full_sample_id" | sed 's/-[0-9]\+$//')
    
#     # Check if the original base ID belonged to JC or JA pool
#     if grep -q -w "^$base_id" "$curr_JC_ids_file"; then
#         echo "$full_sample_id" >> "$JC_IDS_list_file"
#     elif grep -q -w "^$base_id" "$curr_JA_ids_file"; then
#         echo "$full_sample_id" >> "$JA_IDS_list_file"
#     fi
# done < "$BOOT_FOLDER/final_vcf_samples.txt"

# rm -f "$BOOT_FOLDER/final_vcf_samples.txt"


# # 6. Extract subgroup VCFs containing accurate individual counts
# bcftools view \
#     -S "$JC_IDS_list_file" \
#     -T "$loci_ID_file" \
#     "$FINAL_VCF" \
#     -Oz -o "$BOOT_FOLDER/vcf/only_JC.vcf.gz"

# bcftools view \
#     -S "$JA_IDS_list_file" \
#     -T "$loci_ID_file" \
#     "$FINAL_VCF" \
#     -Oz -o "$BOOT_FOLDER/vcf/only_JA.vcf.gz"
