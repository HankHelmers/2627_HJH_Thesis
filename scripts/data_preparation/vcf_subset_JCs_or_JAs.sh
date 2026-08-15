# We can also subset based on the namings in the future. 




# Example used in the PCs:
# 
# Location and name of VCF file within the data folder 
# # Ex: "Ebrahimi_3_3_2026_download/minivcf.vcf.gz"
# VCF_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_download/minivcf.vcf.gz"
# EXTRACT_IDS_FILE_LOC="$DATA_LOC/Ebrahimi_3_3_2026_download/JC_LabIDs.txt"
# EXTRACTED_VCF_FILE_LOC="$EXP_OUTPUT_PATH/extracted"
# PCA_NAME="PCA_JC_pruned"

# # Create output directory (if needed)
# mkdir -p "$EXP_OUTPUT_PATH"

# # ---- Experiment

# # Create extracted VCF 
# plink --vcf $VCF_FILE_LOC --double-id --allow-extra-chr --set-missing-var-ids @:# \
#     --keep $EXTRACT_IDS_FILE_LOC \
#     --recode vcf \
#     --out $EXTRACTED_VCF_FILE_LOC