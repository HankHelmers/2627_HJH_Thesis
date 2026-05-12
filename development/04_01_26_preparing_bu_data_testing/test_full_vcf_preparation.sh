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

plink --vcf final_subset.vcf.gz \
    --const-fid 1 \
    --allow-extra-chr \
    --set-missing-var-ids @:# \
    --recode structure \
    --out test

# Remove the top two lines of LOCI names not needed (& of the wrong format)
# Note: All elements in col 2 are removed in the 'cut' command, so if you add the loci back
#       you need to be sure to not remove the col 2 from the loci rows (rows 1 & 2) 
sed '1,2d' "test.recode.strct_in" > "test_no_loci_id.recode.strct_in"

# Remove the population column (column 2) as we won't be using that prior
cut -d' ' -f1,3- test_no_loci_id.recode.strct_in > test_no_pop.str


# Testing
# plink --vcf minivcf.vcf.gz \
#     --const-fid 1 \
#   --allow-extra-chr \
#   --set-missing-var-ids @:# \
#   --recode vcf \
#   --out test


# plink --vcf "renamed_ind.vcf" \
#   --double-id \
#   --make-bed \
#   --out step1

# #   plink --bfile afterQC --chr-set 29 --recode structure --out forStructure

# plink --bfile step1 \
#   --chr-set 16 \
#   --recode structure \
#   --out final_structure

