library(dplyr)
library(tidyr)
library(readr)
library(vcfR)
library(stringdist)

home_dir <- paste0(getwd(), "/data/raw_input/Ebrahimi_5_20_2026_download/")

full_ids <- read_csv(paste0(home_dir, "sample_info.csv"))
spatial_isolated_JC_ids <- read_csv(paste0(home_dir, "spatial_isolated_JC_ids.csv"))

full_ids <- full_ids %>% mutate(LabID = tolower(LabID)) %>% mutate(numeric_id = )

full_ids <- full_ids %>%
  separate_wider_delim(
    cols = LabID,
    delim = "_",
    names = c("numeric_LabID", "rest_LabID"), # Name your new columns here
    too_many = "merge",                 # What to do if there are > 1 underscores
    too_few = "align_start"            # What to do if there is no underscore
  )

spatial_isolated_JC_ids <- spatial_isolated_JC_ids %>%
  separate_wider_delim(
    cols = LabID,
    delim = "_",
    names = c("numeric_LabID", "rest_LabID"), # Name your new columns here
    too_many = "merge",                 # What to do if there are > 1 underscores
    too_few = "align_start"            # What to do if there is no underscore
  )

intersected <- tibble(LabID = semi_join(full_ids, spatial_isolated_JC_ids, by = "numeric_LabID"))
