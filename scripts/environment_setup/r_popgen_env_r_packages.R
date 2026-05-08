# ============================================================
# Setup R packages for r_popgen_env (conda-managed R env)
# ============================================================

message("Checking R environment...")

# Ensure CRAN repo is set
options(repos = c(CRAN = "https://cloud.r-project.org"))

# ------------------------------------------------------------
# Packages already provided by conda (DO NOT reinstall here):
# - tidyverse
# - data.table
# - adegenet
# - vcfr
# - pegas
# - r-irkernel
# - bcftools (system tool, not R)
# ------------------------------------------------------------

# install pophelper package from GitHub
remotes::install_github('royfrancis/pophelper')

# ------------------------------------------------------------
# Print library path (sanity check)
# ------------------------------------------------------------

message("\nCurrent library paths:")
print(.libPaths())

message("\nSetup complete.")