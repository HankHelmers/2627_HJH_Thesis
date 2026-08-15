# 
# Purpose: Subset the number of individuals and loci within a given VCF.
#
#          Input a VCF (all inds and loci) and output a subsetted VCF based on other parameters.
# 
#          Important notes:
#          - INDS: Individual subsetting requires a mapping.txt file of format [orginal_name INDX]
#            as the script will use the INDX name to determine the appropriate numbers
#                 - A mapping of this kind can be created using the vcf_rename_ids script
#                   The script itself doesn't implement on its own for generality.
#                   
#           - LOCI: The loci are subsampled randomly 

# INPUTS
RAW_VCF_INPUT=$1
IND_SAMPLED_FILE=$2
NUM_LOCI=$3
OUTPUT_FILE=$4
OUTPUT_PATH=$5

echo $IND_SAMPLED_FILE
echo $NUM_LOCI
echo $OUTPUT_PATH

# Subset NUM_LOCI random snips
bcftools view -H  $RAW_VCF_INPUT | shuf -n $NUM_LOCI | cut -f1,2 > "$OUTPUT_PATH/subsampled_snps.txt"

# Generate subset from samples.txt and snps.txt
bcftools view \
    -S "$IND_SAMPLED_FILE"  \
    -T "$OUTPUT_PATH/subsampled_snps.txt" \
    $RAW_VCF_INPUT \
    -Oz -o "$OUTPUT_FILE"
    # -Oz: output, (z-compressed, v-plain text) 

# Count of samples
bcftools query -l "$OUTPUT_FILE" | wc -l

# Count number of snps
bcftools view -H "$OUTPUT_FILE" | wc -l
