# VCF --> Structure plink command

FILE_LOC="renamed_inds.vcf"
OUTPUT_LOC="$(pwd)"
FILE_NAME="final_structure"

# # Fix chromosome names
# awk 'BEGIN{OFS="\t"} 
# /^#/ {print; next} 
# {sub(/_.*/, "", $1); print}' $FILE_LOC > renamed_chr.vcf

# head -n 40 renamed_chr.vcf | sed -n l

# # 1. Normalize
# bcftools norm -m -any $FILE_LOC -Oz -o norm.vcf.gz

# # 2. Set clean IDs
# bcftools annotate \
#   --set-id '%CHROM:%POS:%REF:%ALT' \
#   norm.vcf.gz \
#   -Oz -o clean.vcf.gz

# # 3. Index
# bcftools index clean.vcf.gz

plink --vcf minivcf.vcf/minivcf.vcf \
    --const-fid 1 \
    --allow-extra-chr \
    --set-missing-var-ids @:# \
    --recode structure \
    --out test

# Testing
# plink --vcf minivcf.vcf.gz \
#     --const-fid 1 \
#   --allow-extra-chr \
#   --set-missing-var-ids @:# \
#   --recode vcf \
#   --out test

# Remove the top two lines of LOCI names not needed (& of the wrong format)
# sed '1,2d' "test.recode.strct_in" > "test_clean.recode.strct_in"

# plink --vcf "renamed_ind.vcf" \
#   --double-id \
#   --make-bed \
#   --out step1

# #   plink --bfile afterQC --chr-set 29 --recode structure --out forStructure

# plink --bfile step1 \
#   --chr-set 16 \
#   --recode structure \
#   --out final_structure

