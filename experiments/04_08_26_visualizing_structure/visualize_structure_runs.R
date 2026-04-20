#
#   Reads in the Q-values from multiple outputs from STRUCTURE runs 
#   and summarizes. 
#
# example use: https://www.royfrancis.com/pophelper/reference/readQ.html             

# # install pophelper dependencies
# install.packages(c("ggplot2","gridExtra","label.switching","tidyr","remotes"),repos="https://cloud.r-project.org")
# # install pophelper
# remotes::install_github('royfrancis/pophelper')

# load library for use
library(pophelper)
library(dplyr)
library(purrr)
library(ggplot2)
library(readr)

# INPUTS
exp_output_folder <- "2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs"
str_results_folder <- "2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs/structure"
original_structure_input_file <- "2627_HJH_Thesis/data/Ebrahimi_3_3_2026_prepared/subsampled_pure_jc_ja.str.str"
number_of_runs <- 5

# Collect Runs
sfiles <- list.files(str_results_folder, full.names=TRUE) 

# create a qlist of all runs (each a sfile or structure file)
slist <- readQ(sfiles,filetype="structure")
slist <- alignK(slist)
slist <- sortQ(slist) # sort individuals by Q

# Summarize basic information in the structure files
table <- tabulateQ(slist, sorttable = TRUE, writetable = FALSE, exportpath = NULL)
summary <- summariseQ(table)
print(summary)

# Reference for plots:https://www.royfrancis.com/pophelper/reference/plotQ.html#examples
plotQ(qlist=slist[1:number_of_runs],imgoutput="join", 
sortind="all",sharedindlab = FALSE,exportpath=exp_output_folder)



# Re-attach individual ids
# structure_input <- read.table(original_structure_input_file,sep=" ",
#                               quote="",stringsAsFactors=FALSE)
# ind_ids <- structure_input[[1]] # vector of names

