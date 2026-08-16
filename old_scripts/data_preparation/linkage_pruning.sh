# ----
# Generate linkage_pruned data for a provided VCF
#
# Inputs
#   - #1: Full file location to VCF location (in data)
#   - #2: Full file location to output (in experiments_output)
# 
# Assumptions
#   - Run within experiment folder
#   - Will create an output folder 

# Get inputs
VCF_LOC=$1
EXP_OUTPUT_LOC=$2

# perform linkage pruning - i.e. identify prune sites
plink --vcf $VCF_LOC --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out $EXP_OUTPUT_LOC/linkage

# Make output directory, move into output dir 
mkdir -p "$EXP_OUTPUT_LOC/linkage_pruning"
mv "$EXP_OUTPUT_LOC/linkage."* "$EXP_OUTPUT_LOC/linkage_pruning"