# 
#  Given an experiment number, search through each bootstrap
#  and read in each run from the most recent bootstrap into
#  a csv. 
#
# install.packages("reticulate")

# Verify library and R match
R.home("bin")
.libPaths()

# LIBRARIES --------------------
library(pophelper)

# CONFIGURATION ----------------
setwd("/work/williarj/williarj/2627_HJH_Thesis/")
list.dirs(full.names = FALSE, recursive = FALSE)

exp_id <- 1

exp_folder <- paste0("data/generated_input/experiment_", exp_id, "/")

# Eventually loop through each boot
# Collect the runs from boot 1
boot_num <- 1

# Collect Runs
boot_results_folder <- paste0(exp_folder, "boot", boot_num, "/str_output")
  
# Each folder was a seperate time it run was attempted
run_folders <- list.dirs("data/generated_input/experiment_1/boot1/str_outputs", recursive = FALSE)
recent_run_folder <- tail(sort(run_folders), 1)

# Get run files in recent_run_folder and select only the run_files (run1_f)
sfiles <- list.files(recent_run_folder, full.names = TRUE)
run_files <- sfiles[grepl("_f$", basename(sfiles))] # get only run files

# Read the runs and automatically extract the individual labels
q_list <- readQ(files = run_files, filetype="structure", indlabfromfile = TRUE)

# Prepare for visualization 
# slist <- sort_q_manual(slist)   # Manually sort in increasing order
slist <- as.qlist(slist)        # Add metadata back 

slist <- alignK(slist)
str(slist)

# Run from structre q-values, see output 

# Summarize into a consective CSV per experiment
# experiment_ID	bootstrap_ID	time_run ind_id	hybrid_status	q-value-pop1 q-value-pop2