# Generates all the bootstrap instances for an
# experiment with its unique properties.
#
# If vary_JC/JA_pop are true, each instance of the 
# bootstrap will resample. Same with vary_loci.
#
# Otherwise, one file of listed loci will be used. 

EXP_FOLDER=$1 
raw_data_file_loc=$2 # INPUT VCF
num_bootstraps=$3

JC_IDS_list_file=$4  # List of possible JC ids to subset from
JA_IDS_list_file=$5  # List of possible JA ids to subset from
num_JC_inds=$6       # Number of JC to sample
num_JA_inds=$7       # Number of JA to sample
num_F1=$8
num_BC1=$9 
num_BC2=${10}
vary_JC_pop=${11} 
vary_JA_pop=${12} 

num_loci=${13}
vary_loci=${14}

echo "=== Input Argument Check ==="
echo "EXP_FOLDER:         ${1}"
echo "raw_data_file_loc:  ${2}"
echo "num_bootstraps:     ${3}"
echo "JC_IDS_list_file:   ${4}"
echo "JA_IDS_list_file:   ${5}"
echo "num_JC_inds:        ${6}"
echo "num_JA_inds:        ${7}"
echo "num_F1:             ${8}"
echo "num_BC1:            ${9}"
echo "num_BC2:            ${10}"
echo "vary_JC_pop:        ${11}"
echo "vary_JA_pop:        ${12}"
echo "num_loci:           ${13}"
echo "vary_loci:          ${14}"
   
# FOR i BOOTSTRAP (num_bootstraps)
for boot_num in $(seq 1 $num_bootstraps)
do
    # 0. Generate folders with structure
    #  /boot_{i}       - parent folder for this bootstrap
    #       /vcf     - folder of all generated vcfs
    #       /genepop - folder for the generated genepop
    #       /str     - folder for the structure files
    #       ind_ids.txt  -  .txts for that boot's 
    #       loci_ids.txt - above but loci 
    echo "-------------------------------"

    CURR_BOOT_FOLDER="$EXP_FOLDER/boot$boot_num"
    CURR_VCF_FOLDER="$CURR_BOOT_FOLDER/vcf"
    CURR_GENEPOP_FOLDER="$CURR_BOOT_FOLDER/genepop"
    CURR_STR_FOLDER="$CURR_BOOT_FOLDER/str"
    mkdir -p "$CURR_BOOT_FOLDER"
    mkdir -p "$CURR_VCF_FOLDER"
    mkdir -p "$CURR_GENEPOP_FOLDER"
    mkdir -p "$CURR_STR_FOLDER"

    # Create ind id file
    curr_inds_ids_file="$CURR_BOOT_FOLDER/ind_ids.txt"
    > "$curr_inds_ids_file"
    
    # -------------------------------------
    # Prepare the inds_ids.txt and loc_ids.txt to 
    # go into generate_bootstrap_with

    # -------------------------------------
    # 1. Individuals
    # Get random subset of num_JC_inds, num_JA_inds from
    # JC_IDS_list_file JA_IDS_list_file

    # We want to re-sample JC individuals IF 
    # 1. vary_JC_pop is TRUE (1), always run
    # 2. Otherwise, need to sample at least once at the first boot
    echo "Bootstrap #$boot_num"
    if [ "$vary_JC_pop" -eq 1 ] || [ "$boot_num" -eq 1 ]; then
        echo "Re-sample JC"
        
        # Select random lines from JC/A_sample_names.txt 
        # * -r is VERY important as its sampling with replacement!
        shuf -r -n $num_JC_inds $JC_IDS_list_file | cut -f1,2 >> $curr_inds_ids_file
    else 
        # Select current id list from BOOT1
        echo "Same JC sample as boot1"
        cat "$EXP_FOLDER/boot1/ind_ids.txt" >> $curr_inds_ids_file
    fi

    if [ "$vary_JA_pop" -eq 1 ] || [ "$boot_num" -eq 1 ]; then
        echo "Re-sample JA"
        # current_ids_list should be within /bootX folder
        # current_ids_list = Get random subset of JC_IDS_list_file 
    fi

    # -------------------------------------
    # 2. Loci
    # Get random subset of num_loci from raw_data_file_loc's list of loci

    # Retrieve raw_data_file_loci's list of loci 
    # bcftools view -H  $raw_data_file_loc > # VCF

    if [ "$vary_loci" -eq 1 ] || [ "$boot_num" -eq 1 ]; then
        echo "Re-sample loci"
        #   re-sample 
        #   update current ids list 
    fi
done