#!/usr/bin/env Rscript

# ------------------------------------------------------------------------------
# Command Line Argument Parsing
# ------------------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 3) {
  stop("Error: Missing arguments.\nUsage: Rscript script.R <INPUT_GENEPOP> <OUTPUT_GENEPOP> <BACKCROSS_NUMBER>\n", call. = FALSE)
}

# FOR TESTING 
# BOOT_FOLDER <- "/work/williarj/williarj/2627_HJH_Thesis/data/generated_input/experiment_0/boot1"
# CURRENT_GEN_RAW=paste0(BOOT_FOLDER, "/tmp/gen_2_raw.gen")
# CURRENT_GEN_FINAL=paste0(BOOT_FOLDER, "/genepop/gen_2_hybrids.gen")
# 
# input_path   <- CURRENT_GEN_RAW # newly generated hyb gen output, RAW
# output_path  <- CURRENT_GEN_FINAL # final processed path
# bc_number    <- 1 # which backcross it is

input_path   <- args[1] # newly generated hyb gen output, RAW
output_path  <- args[2] # final processed path
bc_number    <- args[3] # which backcross it is

replacement_label <- paste0("BC", bc_number, "HYB_")

# ------------------------------------------------------------------------------
# Process Genepop File Lines
# ------------------------------------------------------------------------------
if (!file.exists(input_path)) {
  stop(paste("Error: File not found -", input_path), call. = FALSE)
}

file_lines <- readLines(input_path)

# Track the structural positions of your population splits
pop_indices <- which(grepl("^Pop", file_lines, ignore.case = TRUE))

if (length(pop_indices) < 3) {
  stop(paste("Error: Expected at least 3 'Pop' headers, but only found", length(pop_indices)), call. = FALSE)
}

# ------------------------------------------------------------------------------
# Step 1: Remove the second population block entirely
# ------------------------------------------------------------------------------
cat("Removing population block 2 (F1 cohort)...\n")
flush.console()

start_pop2 <- pop_indices[2]
end_pop2   <- pop_indices[3] - 1

# Generate a logical index vector to keep track of lines to preserve
lines_to_keep <- rep(TRUE, length(file_lines))
lines_to_keep[start_pop2:end_pop2] <- FALSE

# Subset the file lines to drop the entire second block
clean_lines <- file_lines[lines_to_keep]

# ------------------------------------------------------------------------------
# Step 2: Modify the remaining third population block (now shifted to block 2)
# ------------------------------------------------------------------------------
# Re-locate the Pop headers in our newly subsetted text vector
new_pop_indices <- which(grepl("^Pop", clean_lines, ignore.case = TRUE))
start_pop3_new  <- new_pop_indices[2]
end_pop3_new    <- length(clean_lines)

cat(sprintf("Modifying new population block 2 to %s...\n", replacement_label))
flush.console()

for (i in start_pop3_new:end_pop3_new) {
  if (grepl(",", clean_lines[i])) {
    clean_lines[i] <- gsub("F1HYB_", replacement_label, clean_lines[i], ignore.case = TRUE)
  }
}

# ------------------------------------------------------------------------------
# Output Final File
# ------------------------------------------------------------------------------
writeLines(clean_lines, output_path)
cat(sprintf("Successfully updated file and exported to %s\n", output_path))
flush.console()
