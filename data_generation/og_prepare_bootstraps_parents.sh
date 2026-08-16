# Generate an arbitrary number of JC/JA 
# parent populations for creating hybrid 
# populations.

NUM_SAMPLED_LOC=500
NUM_BOOTSTRAPS=10 # Number of parent subsamples to make
NUM_PARENTS_IN_POP=10 # Number of each JC/JA in bootstrap

INPUT_VCF="1_renamed_inds_original.vcf"
JC_IDS="JC_sample_names.txt"
JA_IDS="JA_sample_names.txt"
BOOTSTRAP_ID_FOLDER="Bootstrap_ID_Lists"
BOOTSTRAP_VCF_FOLDER="Bootstrap_VCF"

# 1. SNPs: Get list of random NUM_SAMPLED_LOC of the INPUT_VCF
bcftools view -H  $INPUT_VCF | shuf -n $NUM_SAMPLED_LOC | cut -f1,2 > "list_of_${NUM_SAMPLED_LOC}_random_loci.txt"

# 2. Populations: Get some number of random JC and JA parents from each 
    # Files JC/A_sample_names.txt contain a list of the ID names for each 
    # Note the numbers correspond to the order within the original VCF

    # Make folder for bootstraps and VCFs
    mkdir -p $BOOTSTRAP_ID_FOLDER
    mkdir -p $BOOTSTRAP_VCF_FOLDER

    # For each bootstrap population 
for i in $(seq 1 $NUM_BOOTSTRAPS)
do
    SUBSAMPLE_INDS_FILE=$BOOTSTRAP_ID_FOLDER/"${i}_list_${NUM_PARENTS_IN_POP}_JC_JA.txt"

    # Select random lines from JC/A_sample_names.txt 
    # * -r is VERY important as its sampling with replacement!
    shuf -r -n $NUM_PARENTS_IN_POP $JC_IDS | cut -f1,2 > $BOOTSTRAP_ID_FOLDER/"${i}_list_of_${NUM_PARENTS_IN_POP}_random_JC_ids.txt"
    shuf -r -n $NUM_PARENTS_IN_POP $JA_IDS | cut -f1,2 > $BOOTSTRAP_ID_FOLDER/"${i}_list_of_${NUM_PARENTS_IN_POP}_random_JA_ids.txt"

    # Combine together for IDs to subset on
    cat $BOOTSTRAP_ID_FOLDER/"${i}_list_of_${NUM_PARENTS_IN_POP}_random_JC_ids.txt" \
        $BOOTSTRAP_ID_FOLDER/"${i}_list_of_${NUM_PARENTS_IN_POP}_random_JA_ids.txt" \
        > $SUBSAMPLE_INDS_FILE
    
    rm $BOOTSTRAP_ID_FOLDER/"${i}_list_of_${NUM_PARENTS_IN_POP}_random_JC_ids.txt"
    rm $BOOTSTRAP_ID_FOLDER/"${i}_list_of_${NUM_PARENTS_IN_POP}_random_JA_ids.txt"

    # Sort and move duplicate sample IDs into a seperate file 
    #   This is needed because bcftools doesn't allow duplicates in sample
    sort $SUBSAMPLE_INDS_FILE | uniq -d > $BOOTSTRAP_ID_FOLDER/"${i}_duplicates.txt" 

    # Remove duplicates from other file
        # sort -u outputs the duplicate free into a temp file
        # then we override the original with temp!
    sort -u "$SUBSAMPLE_INDS_FILE" > temp.txt && mv temp.txt "$SUBSAMPLE_INDS_FILE" 

    # In ORIGINAL VCF, apply subsample of random loci and parents 
    bcftools view \
        -S $SUBSAMPLE_INDS_FILE  \
        -T "list_of_${NUM_SAMPLED_LOC}_random_loci.txt" \
        $INPUT_VCF \
        -Oz -o $BOOTSTRAP_VCF_FOLDER/${i}_list_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz
        # -Oz: output, (z-compressed, v-plain text) 

    # In DUPLICATE VCF, apply subsample of random loci and parents
    bcftools view \
        -S $BOOTSTRAP_ID_FOLDER/"${i}_duplicates.txt"   \
        -T "list_of_${NUM_SAMPLED_LOC}_random_loci.txt" \
        $INPUT_VCF \
        -Oz -o $BOOTSTRAP_VCF_FOLDER/${i}_list_dups_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz
        # -Oz: output, (z-compressed, v-plain text) 

    # Index both files before merging
    bcftools index $BOOTSTRAP_VCF_FOLDER/${i}_list_dups_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz 
    bcftools index $BOOTSTRAP_VCF_FOLDER/${i}_list_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz 

    # Re-merge with the indexed duplicates
    bcftools merge \
        --force-samples \
        -Ov -o $BOOTSTRAP_VCF_FOLDER/${i}_final_subsample.vcf \
        $BOOTSTRAP_VCF_FOLDER/${i}_list_dups_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz \
        $BOOTSTRAP_VCF_FOLDER/${i}_list_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz \
        >/dev/null

    # Remove intermediate VCFs and their indexing files (.csi) 
    rm $BOOTSTRAP_VCF_FOLDER/${i}_list_dups_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz
    rm $BOOTSTRAP_VCF_FOLDER/${i}_list_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz
    rm $BOOTSTRAP_VCF_FOLDER/${i}_list_dups_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz.csi
    rm $BOOTSTRAP_VCF_FOLDER/${i}_list_of_${NUM_PARENTS_IN_POP}_JC_JA.vcf.gz.csi


    echo "SNP size"
    bcftools view -H $BOOTSTRAP_VCF_FOLDER/${i}_final_subsample.vcf | wc -l

    echo "Pop size"
    bcftools query -l $BOOTSTRAP_VCF_FOLDER/${i}_final_subsample.vcf | wc -l
done
