

suppressPackageStartupMessages(library(adegenet))
suppressPackageStartupMessages(library(dartR))


# Convert Genepop to VCF
# Example input:
# - input_file <- "data/Ebrahimi_3_3_2026_subsets_labeled/genepop/3_subsampled_top10_loci200_f1s.gen"
# - output_path <- "data/Ebrahimi_3_3_2026_subsets_labeled/VCF/"
# - out_filename <- "3_subsampled_top10_loci200_f1s"
genepop_to_vcf <- function(input_file, output_path, out_filename) { 
    print(cat("GENEPOP to VCF conversion began for ", out_filename))

    # If plink not installed, conversion not possible:
    plink_loc <- Sys.which("plink")
    if (plink_loc == "") {
        print("Plink loc not found. Ensure plink is installed.")
        return()
    }

    # Read in .gen file
    gen <- adegenet::read.genepop(input_file)

    # Convert to genlight (gl)
    gl <- dartR::gi2gl(gen)

    # Use darkR to go from gl to VCF
    dartR::gl2vcf(
        gl,
        outfile = out_filename,
        outpath = output_path,
        plink_path=dirname(plink_loc)
    )
}

# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

print(cat("Number of arguments: ", length(args)))

if (length(args) != 3) {
    stop("Usage: genepop_to_vcf <input_vcf_file> <output_file> <out_filename>")
}

genepop_to_vcf(args[1], args[2], args[3])


