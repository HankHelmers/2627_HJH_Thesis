# install.packages("vcfR")
# install.packages("adegenet")
library(vcfR)
library(adegenet) # ls("package:adegenet")

vcf_file <- "2627_HJH_Thesis/data/Ebrahimi_3_3_2026_download/renamed_inds.vcf"
out_file <- "2627_HJH_Thesis/data/Ebrahimi_3_3_2026_prepared/out.str"

# Read VCF
vcf <- read.vcfR(vcf_file)

# vcf@gt <- vcf@gt[, c("IND1", "IND2", "IND3")]

# write.vcf(vcf, "subset_file.vcf")

# Convert to genind
genind_obj <- vcfR2genind(vcf)

# Test a subset
genind_obj <- genind_obj[1:50, ]

# Convert to STRUCTURE format
# adegenet does not export directly, so we write manually

geno <- tab(genind_obj)  # genotype matrix
inds <- indNames(genind_obj)

# Split diploid columns
split_geno <- function(x) {
  alleles <- strsplit(as.character(x), "")
  sapply(alleles, function(a) {
    if (length(a) < 2) return(c(0,0))
    return(as.numeric(a))
  })
}

# Write STRUCTURE format
con <- file(out_file, "w")

for (i in 1:nrow(geno)) {
  line <- c(inds[i], 1)  # population = 1
  for (j in 1:ncol(geno)) {
    g <- geno[i, j]
    if (is.na(g)) {
      line <- c(line, 0, 0)
    } else {
      # assumes diploid encoded as 11, 12, etc.
      a1 <- floor(g / 10)
      a2 <- g %% 10
      line <- c(line, a1, a2)
    }
  }
  writeLines(paste(line, collapse=" "), con)
}

close(con)

# vcf_to_genid <- function(vcf_path, out_path) {
#     # Read in VCF using v
#     vcf_data <- read.vcfR(vcf_path)

#     genind_object <- vcfR2genind(vcf_data)


# }

# # ---- CLI entry point
# args <- commandArgs(trailingOnly = TRUE)

# if (length(args) != 2) {
#     stop("Usage: number of args incorrect")
# }

# generate_pca_plots(args[1], args[2], args[3], as.numeric(args[4]), args[5])