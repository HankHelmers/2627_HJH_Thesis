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
IND_MAPPING_FILE=$2
NUM_INDS=$3
NUM_LOCI=$4
OUTPUT_FILE_NAME=$5
OUTPUT_PATH=$6

# Subset to top 50 individuals
head -n $NUM_INDS $IND_MAPPING_FILE | awk '{print $1}' > "$OUTPUT_PATH/subsampled_inds.txt"          # Generates the text with IDs to retain

# Subset NUM_LOCI random snips
bcftools view -H  $RAW_VCF_INPUT | shuf -n $NUM_LOCI | cut -f1,2 > "$OUTPUT_PATH/subsampled_snps.txt"

# Generate subset from samples.txt and snps.txt
bcftools view \
    -S "$OUTPUT_PATH/subsampled_inds.txt"  \
    -T "$OUTPUT_PATH/subsampled_snps.txt" \
    $RAW_VCF_INPUT \
    -Oz -o "$OUTPUT_PATH/$OUTPUT_FILE_NAME.vcf.gz"
    # -Oz: output, (z-compressed, v-plain text) 

# Count of samples
bcftools query -l "$OUTPUT_PATH/$OUTPUT_FILE_NAME.vcf.gz" | wc -l

# Count number of snps
bcftools view -H "$OUTPUT_PATH/$OUTPUT_FILE_NAME.vcf.gz" | wc -l
