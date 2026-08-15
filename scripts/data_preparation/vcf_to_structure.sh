#
#
# Script for converting vcf to an input file for NewHybrids (Anderson and Thompson 2002)
#
#

INPUT_VCF_FILE=$1
PREPARED_OUTPUT_PATH=$2
FINAL_STRUCTURE_FILE=$3

#       Plink --vcf to --structure
#       --const-fid 1 = Give all individuals a constant famild id (fid)
#       --allow-extra-chr = chromosome names have 1_NAME
plink --vcf $INPUT_VCF_FILE \
    --const-fid 1 \
    --allow-extra-chr \
    --set-missing-var-ids @:# \
    --recode structure \
    --out intermediate

    # --chr-set 29 \

# Remove the top two lines of LOCI names not needed (& of the wrong format)
#       Note: All elements in col 2 are removed in the 'cut' command, so if you add the loci back
#             you need to be sure to not remove the col 2 from the loci rows (rows 1 & 2) 
sed '1,2d' "intermediate.recode.strct_in" > "intermediate_no_loci_id.recode.strct_in"

# Remove the population column (column 2) as we won't be using that prior
cut -d' ' -f1,3- "intermediate_no_loci_id.recode.strct_in" > "$FINAL_STRUCTURE_FILE"

# Remove intermediates 
rm intermediate*

