# DEPRECATED #####################################

#!/bin/bash
which structure # verify accessible

# specify the folder of experiment in future, so can run generally
# specify the in and out files for data (within the mainparams)

file_location="/work/williarj/williarj/2627_HJH_Thesis"

# data params
NUMINDS=299
NUMLOCI=12
LABEL=1
MISSING=-9

# alg params
BURNIN=5000
NUMREPS=1000  # run length

# files 
INFILE="${file_location}/data/lepais_structure.str"
OUTFILE="${file_location}/experiment_outputs/03_14_26_testing_structure_lepais/structure/{OUTPUT_FILE_NAME}"

# -----------------------------
# create base params for this experiment
cp "${file_location}/scripts/template_structure_parameters/template_structure_mainparams" mainparams_exp_template

# Replace placeholders in-place using sed
# data params
sed -i "s/{NUMINDS}/${NUMINDS}/g" mainparams_exp_template
sed -i "s/{NUMLOCI}/${NUMLOCI}/g" mainparams_exp_template
sed -i "s/{LABEL}/${LABEL}/g" mainparams_exp_template
sed -i "s/{MISSING}/${MISSING}/g" mainparams_exp_template

# alg params
sed -i "s/{BURNIN}/${BURNIN}/g" mainparams_exp_template
sed -i "s/{NUMREPS}/${NUMREPS}/g" mainparams_exp_template

# files
sed -i "s|{INFILE}|${INFILE}|g" mainparams_exp_template
sed -i "s|{OUTFILE}|${OUTFILE}|g" mainparams_exp_template

for i in {1..5}; do
    # copy mainparams for each run 
    cp mainparams_exp_template "mainparams_run${i}"
    
    # replace outfile with dynamic name
    sed -i "s|{OUTPUT_FILE_NAME}|run${i}|g" "mainparams_run${i}"

    structure -m "mainparams_run${i}" -e extraparams
done 


# for TRIAL in `seq 1 10` # run 10 loops simultaneously
# do
#  	# Define output random seed file
# 	OUTFILE_SEED="../output/cycling_1year_trial${TRIAL}_randomseed.txt"
	
# 	# Run SLiM and save output as VCF and random seed in .txt
# 	/work/williarj/williarj/slim/slim -d trialNumber=${TRIAL} cycling_1year.slim > "$OUTFILE_SEED"

# 	# Extract the random seed from line 2 of the .txt output
# 	RANDOM_SEED=$(sed -n '2p' "$OUTFILE_SEED")

# 	# Append trial number and seed to CSV
# 	echo "cycling_1year_trial${TRIAL},${RANDOM_SEED}" >> "../output/compiled_random_seeds.csv"
	
# 	# Remove the intermediate random seed file 
# 	rm "$OUTFILE_SEED"
# done