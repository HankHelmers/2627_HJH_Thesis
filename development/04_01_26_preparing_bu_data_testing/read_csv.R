library(readr)
library(dplyr)

home_dir <- "2627_HJH_Thesis/data/Ebrahimi_3_3_2026_download/"

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
  writeLines(paste0(home_dir, "JA_JC_labels.txt"))

# Subset only JA individuals
ja_inds <- tb %>%
  filter(JA >= 0.5)

jc_inds <- tb %>%
  filter(JA <= 0.5)

# ja_inds %>%
#     pull(LabID) %>%
#     writeLines(paste0(home_dir, "JA_LabIDs.txt"))

# Create JC keep file (JA < 0.5)
tb %>%
  filter(JA < 0.5) %>%
  transmute(FID = LabID,          # Using double id
            IID = LabID) %>%
  write.table(
    file = paste0(home_dir, "JC_LabIDs.txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )

tb %>%
  filter(JA > 0.5) %>%
  transmute(FID = LabID,          # Using double id
            IID = LabID) %>%
  write.table(
    file = paste0(home_dir, "JA_LabIDs.txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )


# (Optional) write JA individual IDs
# Replace `SampleID` with your actual column name
# ja_inds %>%
#   pull(SampleID) %>%
#   writeLines(paste0(home_dir, "JA_individuals.txt"))

