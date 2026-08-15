#
#   Reads in the Q-values from multiple outputs from STRUCTURE runs 
#   and summarizes. 
#
# example use: https://www.royfrancis.com/pophelper/reference/readQ.html       

# load library for use
library(pophelper)

# Ex: Input
# exp_output_folder <- "2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs"
# str_results_folder <- "2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs/structure"
# original_structure_input_file <- "2627_HJH_Thesis/data/Ebrahimi_3_3_2026_prepared/subsampled_pure_jc_ja.str.str"
# number_of_runs <- 5

# Working directory is the folder running the script from:
print(getwd())

# Get the sort_q_manual function
source("../../scripts/data_visualization/sort_q_manual.R")

generate_str_plots <- function(exp_output_folder, str_results_folder, original_structure_input_file, number_of_runs, output_file_name) {

    # Collect Runs
    sfiles <- list.files(str_results_folder, full.names = TRUE)

    run_files <- sfiles[grepl("_f$", basename(sfiles))] # get only run files

    print(run_files)

    # create a qlist of all runs (each a sfile or structure file)
    slist <- readQ(run_files,filetype="structure")

    test <- slist[[1]]

    # Summarize basic information in the structure files
    table <- tabulateQ(slist, sorttable = TRUE, writetable = FALSE, exportpath = NULL)
    summary <- summariseQ(table)
    print(summary)

    # Prepare for visualization 
    # slist <- sort_q_manual(slist)   # Manually sort in increasing order
    slist <- as.qlist(slist)        # Add metadata back 
    slist <- alignK(slist)
    str(slist)

    number_of_runs=length(slist)

    # Reference for plots:https://www.royfrancis.com/pophelper/reference/plotQ.html#examples
    plotQ(qlist=slist[1:number_of_runs],imgoutput="join", 
    sortind="all",sharedindlab = FALSE,exportpath=exp_output_folder, outputfilename=output_file_name)
}

# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

print(length(args))

if (length(args) != 5) {
    stop("Usage: script.R <exp_output_folder> <str_results_folder> <original_structure_input_file> <number_of_runs> <output_file_name>")
}

generate_str_plots(args[1], args[2], args[3], as.numeric(args[4]), args[5])
