
# Prepare environment from yaml
# conda env create -f environment.yaml --solver=libmamba

# Activate environment
conda activate r_popgen_env

# Download CRAN R package dependencies 
Rscript setup_r_packages.R


# Useful references
# ------------------------
# Update following additions
# conda env update --file environment.yaml --prune --solver=libmamba

# Remove environment
# conda env remove -n r_popgen_env

# Install new package example
# conda install conda-forge::r-remotes
