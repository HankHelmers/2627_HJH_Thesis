
# I wrote this using the given packages. 
# Someone else wrote another version, if needed @  https://github.com/mscharmann/tools/blob/master/vcf_to_genepop.py

library(vcfR)
library(adegenet)

vcf_to_genepop <- function(input_vcf_file, output_file) {
    #---------------------------
    # READ VCF
    #---------------------------
    vcf <- read.vcfR(input_vcf_file)

    # Extract genotype matrix
    gt <- extract.gt(vcf, element = "GT")

    # Get loci names
    loci <- paste0(vcf@fix[,1], "_", vcf@fix[,2])  # CHROM_POS

    #---------------------------
    # CONVERT GT → GENEPOP FORMAT
    #---------------------------
    convert_gt <- function(x) {
    if (is.na(x) || x == "./.") return("0000")
    
    alleles <- unlist(strsplit(x, "[/|]"))
    if (length(alleles) != 2) return("0000")
    
    a1 <- sprintf("%02d", as.numeric(alleles[1]) + 1)
    a2 <- sprintf("%02d", as.numeric(alleles[2]) + 1)
    
    return(paste0(a1, a2))
    }

    genepop_mat <- apply(gt, c(1,2), convert_gt)

    # transpose: individuals = rows
    genepop_mat <- t(genepop_mat)

    #---------------------------
    # WRITE GENEPOP FILE
    #---------------------------
    con <- file(output_file, "w")

    # Header
    writeLines("VCF_to_GENEPOP", con)

    # Loci
    writeLines(paste(loci, collapse = ","), con)

    # Single population
    writeLines("Pop", con)

    # Individuals
    for (i in 1:nrow(genepop_mat)) {
    line <- paste(rownames(genepop_mat)[i], ",", paste(genepop_mat[i,], collapse=" "))
    writeLines(line, con)
    }

    close(con)

    cat("GENEPOP file written to:", output_file, "\n")
}

# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
    stop("Usage: vcf_to_genepop.R <input_vcf_file> <output_file>")
}

vcf_to_genepop(args[1], args[2])
