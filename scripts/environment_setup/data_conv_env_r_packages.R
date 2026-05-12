# ============================================================
# Setup R packages for r_popgen_env (conda-managed R env)
# ============================================================

message("Checking R environment...")

# Ensure CRAN repo is set
options(repos = c(CRAN = "https://cloud.r-project.org"))


# library(remotes)
# library(devtools)
# devtools::install_github("thierrygosselin/radiator")
# library(radiator)
install.packages("genepop")

# ------------------------------------------------------------
# Print library path (sanity check)
# ------------------------------------------------------------

message("\nCurrent library paths:")
print(.libPaths())

message("\nSetup complete.")