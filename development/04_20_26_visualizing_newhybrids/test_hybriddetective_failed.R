
# Important! You will need conda environment for devtools to work
#   conda has the necessary packages for openssl to work locally.

# Package management
options(repos = c(CRAN = "https://cloud.r-project.org"))

required <- c("ggplot2", "devtools")

missing <- required[!sapply(required, requireNamespace, quietly = TRUE)]

if (length(missing) > 0) {
  install.packages(missing)
}

library(devtools)

# You will also need these: 
# devtools::install_github("rystanley/genepopedit") 
# devtools::install_github("bwringe/hybriddetective", dependencies = FALSE)

library(genepopedit)
library(hybriddetective)

getwd()

# INPUTS
exp_output_folder <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs"
nh_results_folder <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs/newhybrids"
original_structure_input_file <- "/work/williarj/williarj/2627_HJH_Thesis/data/Ebrahimi_3_3_2026_prepared/subsampled_pure_jc_ja.str.str"
number_of_runs <- 5

i <- 1
results_folder <- paste0(nh_results_folder, "/run", i, "/aa-PofZ.txt")
nh_plotR(NHResults = results_folder) ## plot results will be displayed by R 
