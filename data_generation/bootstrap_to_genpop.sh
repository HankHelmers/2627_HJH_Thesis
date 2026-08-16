# With the bootstrapped parent groups in "Bootstrap_VCF"
# Need to turn those into 'GENEPOP' format to be used by the
# recom-sim.

DATA_LOC="$BASE_DIR/../../data"
DATA_FOLDER="$DATA_LOC/Recent_Hybrids_Data/Bootstrap_VCF"

# Collect all the input files from the designated folder
VCF_LIST=( "$DATA_FOLDER"/*.vcf )

for i in ${VCF_LIST[@]}; do 
    INPUT_VCF_FILE="$DATA_FOLDER/VCF/${i}.vcf"

    # Add Pop delinator 
    # # Sort input VCF by names 
    ## TO DO

    OUTPUT_FILE="$DATA_FOLDER/${i}.gen"

    # input VCF
    # output location
    Rscript "$SCRIPTS_LOC/data_preparation/vcf_to_genepop.R" \
        $INPUT_VCF_FILE \
        $OUTPUT_FILE
done

mkdir -p "$DATA_FOLDER/genepop"
mv "$DATA_FOLDER/"*.gen "$DATA_FOLDER/genepop"