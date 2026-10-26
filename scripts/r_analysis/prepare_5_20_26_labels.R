#
#   Specifically for the March Ebrahimi data,
#   this script generates a list of label IDs  
#   for the JC and JA individuals. 
#
#   This identification relies on the "sample_info.csv"
#   provided for the data.
#

library(dplyr)
library(readr)
library(vcfR)

home_dir <- "../../data/Ebrahimi_5_20_2026_download/"
out_dir <- "../../data/Ebrahimi_5_20_2026_prepared/"
input_vcf <- paste0(home_dir, "minivcf_v2.vcf.gz")


# 1. Read the CSV containing sample IDs and groups
metadata <- read_csv(paste0(home_dir, "sample_info.csv"))

# 2. Read the VCF
vcf <- read.vcfR(input_vcf)

# 3. Get the sample names from the VCF
vcf_samples <- colnames(vcf@gt)[-1]

# 4. Match VCF sample names to LabID in the metadata
sample_metadata <- metadata %>%
  filter(LabID %in% vcf_samples) %>%
  mutate(
    new_name = paste0(row_number(), "_", Group)
  )

# 5. Check for samples in the VCF that are missing from the CSV
missing_samples <- setdiff(vcf_samples, metadata$LabID)

if (length(missing_samples) > 0) {
  warning(
    "These VCF samples were not found in the CSV: ",
    paste(missing_samples, collapse = ", ")
  )
}

# 6. Rename matching samples in the VCF
sample_map <- setNames(
  sample_metadata$new_name,
  sample_metadata$LabID
)

new_samples <- vcf_samples
matched <- vcf_samples %in% names(sample_map)
new_samples[matched] <- sample_map[vcf_samples[matched]]

colnames(vcf@gt) <- c("FORMAT", new_samples)

# 7. Write the renamed VCF
write.vcf(vcf, "renamed_samples.vcf")