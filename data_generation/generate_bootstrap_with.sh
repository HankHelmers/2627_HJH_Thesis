# Generate a single bootstrap with the 
# following parameters.

# ----------------------------- Configurations

boot_num, # bootstrap iteration for naming
EXP_FOLDER, 
raw_data_file_loc, 

num_JC_inds, num_JA_inds, 
num_F1, num_BC1, num_BC2, 

vary_JC_pop, vary_JA_pop, 

num_loci, vary_loci

mkdir -p "$EXP_FOLDER/boot$boot_num"