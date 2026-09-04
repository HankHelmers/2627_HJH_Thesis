# With the bootstrapped parent groups in "Bootstrap_VCF"
# Need to turn those into 'GENEPOP' format to be used by the
# recom-sim.

BASE_DIR="/work/williarj/williarj/2627_HJH_Thesis/"   
SCRIPT_LOC="$BASE_DIR/scripts"
DATA_LOC="$BASE_DIR/data"
GENEPOP_FOLDER=$1
VCF_TO_CONVERT=$2

VCF_NAME=$(basename $VCF_TO_CONVERT .vcf.gz)
OUTPUT_FILE="$GENEPOP_FOLDER/$VCF_NAME.gen"

Rscript "$SCRIPT_LOC/data_conversion/vcf_to_genepop.R" \
        $VCF_TO_CONVERT \
        $OUTPUT_FILE

## CONVERTING A LIST OF VCFS
# Collect all the input files from the designated folder
# VCF_LIST=( "$DATA_FOLDER"/*.vcf )
# 
# for i in ${VCF_LIST[@]}; do 
#     INPUT_VCF_FILE="$DATA_FOLDER/VCF/${i}.vcf"

#     # Add Pop delinator 
#     # # Sort input VCF by names 
#     ## TO DO

#     OUTPUT_FILE="$DATA_FOLDER/${i}.gen"

#     # input VCF
#     # output location
#     Rscript "$SCRIPTS_LOC/data_preparation/vcf_to_genepop.R" \
#         $INPUT_VCF_FILE \
#         $OUTPUT_FILE
# done

# mkdir -p "$DATA_FOLDER/genepop"
# mv "$DATA_FOLDER/"*.gen "$DATA_FOLDER/genepop"