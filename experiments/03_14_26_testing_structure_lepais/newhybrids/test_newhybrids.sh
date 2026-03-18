
# data params - for me
# NUMINDS=299
# NUMLOCI=12
# LABEL=1
# MISSING=-9


# file parameters
experiment_name="03_14_26_testing_structure_lepais"
DATAFILENAME="lepais_newhybrids.txt"

# alg params
BURNIN=5000
NUMREPS=1000  # run length

file_location="/work/williarj/williarj/2627_HJH_Thesis"
data_location="${file_location}/data/${DATAFILENAME}"
output_file_location="${file_location}/experiment_outputs/${experiment_name}"
GENOTYPEFILE="genotype_cat_f1"


for i in {1..5}; do
    newhybrids -d ${data_location} -c ${GENOTYPEFILE} --burn-in ${BURNIN} --num-sweeps ${NUMREPS} --no-gui > NewHybridsLog.txt
    wait

    # move files to own directory in output 
    mkdir ${output_file_location}/newhybrids/run${i}
    mv aa* EchoedGtypData.txt NewHybridsLog.txt ${output_file_location}/newhybrids/run${i}
done 


