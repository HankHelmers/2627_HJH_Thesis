# Purpose: (VCF) Rename the individual names within a VCF file using bcftools.
#
#          It works by creating a mapping text between the old names and the new
#          names enabling swapping back and forth if needed. 

# INPUTS
VCF_FILE_LOC=$1
OUTPUT_LOC=$2
FILE_NAME=$3

# Save old VCF individual names into text
bcftools query -l $VCF_FILE_LOC > old_ids.txt

# Create a new list of names based on lengths of the old_ids length
nl -w1 old_ids.txt | awk '{print "IND"$1}' > new_ids.txt

# Rename individuals 
bcftools reheader -s new_ids.txt $VCF_FILE_LOC > "$OUTPUT_LOC/$FILE_NAME.vcf.gz"

# Create a mapping file with old name IND#
nl old_ids.txt | awk '{print $2, "IND"$1}' > "$OUTPUT_LOC/mapping.txt"
rm new_ids.txt
rm old_ids.txt

# Use the mappings as follows 
# Ex: nl mapping.txt | awk '{print $2}' > select_INDS.txt
# head -n $NUM_INDS $IND_MAPPING_FILE | awk '{print $1}' > samples.txt          # Generates the text with IDs to retain

