# 
#  Given an experiment number, search through each bootstrap
#  and read in each run from the most recent bootstrap into
#  a csv. 
#

# CONFIGURATION ----------------
setwd("/work/williarj/williarj/2627_HJH_Thesis/")
list.dirs(full.names = FALSE, recursive = FALSE)

# Verify library and R match
R.home("bin")
.libPaths()

# LIBRARIES --------------------
library(pophelper)
library(dplyr)
library(purrr)

# INPUTS 
exp_id <- 1

# ************************* TESTING                             HERE _test
exp_folder <- paste0("data/generated_input/experiment_", exp_id, "_test/")

# Eventually loop through each boot
# Collect the runs from boot 1
boot_num <- 1

# Collect Runs ******************** TESTING              HERE          _1
boot_results_folder <- paste0(exp_folder, "boot", boot_num, "_1/str_outputs")
  
# Each folder was a seperate time it run was attempted
run_folders <- list.dirs(boot_results_folder, recursive = FALSE)
recent_run_folder <- tail(sort(run_folders), 1)

# Retrieve the runtime from the folder name
raw_time_run      <- basename(recent_run_folder)
time_string <- gsub(".*_([0-9]{8})_([0-9]{6}).*", "\\1\\2", raw_time_run)
parsed_datetime <- as.POSIXct(time_string, format = "%Y%m%d%H%M%S")
time_run <- format(parsed_datetime, "%Y-%m-%d %H:%M:%S")

# Get run files in recent_run_folder and select only the run_files (run1_f)
sfiles <- list.files(recent_run_folder, full.names = TRUE)
run_files <- sfiles[grepl("_f$", basename(sfiles))] # get only run files

# Read the runs and automatically extract the individual labels
q_list <- readQ(files = run_files, filetype="structure", indlabfromfile = TRUE)

# Prepare for visualization 
slist <- lapply(q_list, function(sublist) lapply(sublist, sort)) # sort all sublists
slist <- as.qlist(q_list)                                        # Add metadata back 
slist <- alignK(slist)                                           # Align the population Qs

# Summarize into a CSV per experiment
# experiment_ID	bootstrap_ID	time_run ind_id	hybrid_status	q-value-pop1 q-value-pop2
# JA always pop1?
# JC always pop2
# Combine the individual matrices from the aligned list
# structure runs are held as dataframes inside the aligned qlist
csv_data <- imap_dfr(slist, function(q_matrix, run_name) {
  
  # Extract individual IDs from the row names of the q_matrix
  ind_id <- rownames(q_matrix)
  if (is.null(ind_id)) {
    ind_id <- seq_len(nrow(q_matrix))
  }
  
  # Map columns dynamically to pop1 and pop2 based on your requirements
  # Column names in pophelper usually default to Cluster1, Cluster2, etc.
  q_val_pop1 <- q_matrix[, 1]
  q_val_pop2 <- q_matrix[, 2]
  
  # Safely handle the run number / run ID from the list structure
  # If the list isn't named, run_name will default to the numeric index string (e.g., "1")
  # We use gsub to pull just the numbers if it looks like "run1_f"
  run_id <- if (grepl("[0-9]", run_name)) {
    gsub("[^0-9]", "", run_name)
  } else {
    run_name
  }
  
  # Construct the standardized output per run
  data.frame(
    experiment_ID = exp_id,
    bootstrap_ID  = boot_num,
    time_run      = time_run,
    run_id        = run_id,
    ind_id        = ind_id,
    q_value_pop1_JA  = q_val_pop1,
    q_value_pop2_JC  = q_val_pop2,
    stringsAsFactors = FALSE
  )
})

# Save the final consolidated table into a CSV
output_csv_path <- file.path(paste0("data/outputs/experiment_", exp_id, "_test.csv"))
write.csv(csv_data, file = output_csv_path, row.names = FALSE)



