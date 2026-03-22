# ----
# Generate missing VCF report for a provided VCF and output location.
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

# Run missing report analysis
plink --vcf $VCF_LOC --double-id --allow-extra-chr \
--missing --out $EXP_OUTPUT_LOC/missing_log