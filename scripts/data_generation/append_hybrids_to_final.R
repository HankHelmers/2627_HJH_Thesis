#!/usr/bin/env Rscript

# ------------------------------------------------------------------------------
# Command Line Argument Parsing
# ------------------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  stop("Error: Missing arguments.\nUsage: Rscript script.R <FINAL_GENEPOP> <PREV_GEN_FILE> <PARENT_POOL_GENEPOP>\n", call. = FALSE)
}

# FOR TESTING 
# BOOT_FOLDER <- "/work/williarj/williarj/2627_HJH_Thesis/data/generated_input/experiment_0/boot1"
# PREV_GEN_FILE=paste0(BOOT_FOLDER, "/genepop/gen_2_hybrids.gen")
# CURRENT_GEN_RAW=paste0(BOOT_FOLDER, "/tmp/gen_3_raw.gen")
# CURRENT_GEN_FINAL=paste0(BOOT_FOLDER, "/genepop/gen_3_hybrids.gen")
# PARENT_POOL_GENEPOP=paste0(BOOT_FOLDER, "/tmp/parent_pool_gen_3.gen")
# 
# ALL_HYBRIDS <- paste0(BOOT_FOLDER,"/genepop/all_generations_hybrids.gen")
# CURRENT_GEN_FINAL <- CURRENT_GEN_FINAL

ALL_HYBRIDS <- args[1]
CURRENT_GEN_FINAL <- args[2]

cat(sprintf("Generating a generation of hybrids... "))
flush.console()

# ------------------------------------------------------------------------------
# Helper Function to Process Genepop Subsets
# ------------------------------------------------------------------------------
extract_genepop_individuals <- function(file_path, pattern) {
  if (!file.exists(file_path)) {
    stop(paste("Error: File not found -", file_path), call. = FALSE)
  }
  
  file_lines <- readLines(file_path)
  pop_indices <- which(grepl("^Pop", file_lines, ignore.case = TRUE))
  
  if (length(pop_indices) == 0) {
    return(character(0))
  }
  
  first_pop_index <- pop_indices[1]
  data_lines <- file_lines[first_pop_index:length(file_lines)]
  matched_lines <- data_lines[grepl(",", data_lines) & grepl(pattern, data_lines, ignore.case = TRUE)]
  
  return(matched_lines)
}

# ------------------------------------------------------------------------------
# Execution Pipeline
# ------------------------------------------------------------------------------

# First: Extract preceding hybrid individuals cohort to act as Parent 2 pool
hybrid_individuals <- extract_genepop_individuals(CURRENT_GEN_FINAL, "HYB_")

# Last: Write results sequentially to match original file structure
write(c("Pop", hybrid_individuals), file = ALL_HYBRIDS, append = TRUE)
