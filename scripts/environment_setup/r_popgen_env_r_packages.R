# ============================================================
# Setup R packages for r_popgen_env (conda-managed R env)
# ============================================================

message("Checking R environment...")

# Ensure CRAN repo is set
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Verify access to linux
Sys.which("x86_64-conda-linux-gnu-c++")

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

library(remotes)

# install pophelper package from GitHub
remotes::install_github('royfrancis/pophelper')

install.packages("digest")
install.packages("listenv")
install.packages("parallelly")
install.packages("future")
install.packages("arrow")

remotes::install_github("thierrygosselin/radiator")
library(radiator)

# ------------------------------------------------------------
# Print library path (sanity check)
# ------------------------------------------------------------

message("\nCurrent library paths:")
print(.libPaths())

message("\nSetup complete.")