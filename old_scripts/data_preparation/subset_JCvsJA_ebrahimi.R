#
#   Specifically for the March Ebrahimi data,
#   this script generates a list of label IDs  
#   for the JC and JA individuals. 
#
#   This identification relies on the "sample_info.csv"
#   provided for the data.
#

library(readr)
library(dplyr)

home_dir <- "../../data/Ebrahimi_3_3_2026_download/"
out_dir <- "../../data/Ebrahimi_3_3_2026_prepared/"

# Read data
tb <- read_csv(paste0(home_dir, "sample_info.csv"))

# Add species labels directly to dataframe
tb <- tb %>%
  mutate(spp_label = if_else(JA < 0.5, "JC", "JA"))

# Count labels
tb %>%
  count(spp_label)

# Write ordered labels to file
tb %>%
  pull(spp_label) %>%
  writeLines(paste0(out_dir, "JA_JC_labels.txt"))

# Subset only JA individuals
ja_inds <- tb %>%
  filter(JA >= 0.5)

# Subset only JC individuals 
jc_inds <- tb %>%
  filter(JA <= 0.5)

# Create JC keep file (JA < 0.5)
tb %>%
  filter(JA < 0.5) %>%
  transmute(FID = LabID,          # Using double id
            IID = LabID) %>%
  write.table(
    file = paste0(out_dir, "JC_LabIDs.txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )

tb %>%
  filter(JA > 0.5) %>%
  transmute(FID = LabID,          # Using double id
            IID = LabID) %>%
  write.table(
    file = paste0(out_dir, "JA_LabIDs.txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )
