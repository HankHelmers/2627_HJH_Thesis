
# Prepare environment from yaml
conda env create -f data_conv_env.yaml --solver=libmamba

# Activate environment
conda activate data_conv_env

# Download CRAN R package dependencies 
Rscript data_conv_env_r_packages.R


# Useful references
# ------------------------
# Update following additions
# conda env update --file data_conv_env.yaml --prune --solver=libmamba

# Remove environment
# conda env remove -n r_popgen_env

# Install new package example
# conda install conda-forge::r-remotes
