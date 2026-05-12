exists(".vsc.attach")
.libPaths()

library(pophelper)


exp_output_folder <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_04_21_26_2_str_nh_randomized_subsample"
str_results_folder <-"/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_04_21_26_2_str_nh_randomized_subsample/structure"
original_structure_input_file <-"/work/williarj/williarj/2627_HJH_Thesis/data/lepais_structure.str"
number_of_runs <- 5

# Get the sort_q_manual function
source("/work/williarj/williarj/2627_HJH_Thesis/scripts/data_visualization/sort_q_manual.R")

# Collect Runs
sfiles <- list.files(str_results_folder, full.names=TRUE) 
print(sfiles)

# create a qlist of all runs (each a sfile or structure file)
slist <- readQ(sfiles,filetype="structure")

test <- slist[[1]]

# Summarize basic information in the structure files
table <- tabulateQ(slist, sorttable = TRUE, writetable = FALSE, exportpath = NULL)
summary <- summariseQ(table)
print(summary)

# Prepare for visualization 
slist <- sort_q_manual(slist)   # Manually sort in increasing order
slist <- as.qlist(slist)        # Add metadata back 
slist <- alignK(slist)
str(slist)

# Reference for plots:https://www.royfrancis.com/pophelper/reference/plotQ.html#examples
plotQ(qlist=slist[1:number_of_runs],imgoutput="join", 
sortind="all",sharedindlab = FALSE,exportpath=exp_output_folder)

