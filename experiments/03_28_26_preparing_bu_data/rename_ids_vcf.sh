

FILE_LOC="minivcf.vcf/minivcf.vcf"
OUTPUT_LOC="$(pwd)/Ebrahimi_3_3_2026_prepared"
FILE_NAME="ebrahimi_3_3"

# Save old VCF individual names into text
bcftools query -l $FILE_LOC > old_ids.txt

# Create a new list of names based on lengths of the old_ids length
nl -w1 old_ids.txt | awk '{print "IND"$1}' > new_ids.txt

# Rename individuals 
bcftools reheader -s new_ids.txt $FILE_LOC > renamed_inds.vcf

# Create a mapping file with old name IND#
nl old_ids.txt | awk '{print $2, "IND"$1}' > mapping.txt
rm new_ids.txt
rm old_ids.txt