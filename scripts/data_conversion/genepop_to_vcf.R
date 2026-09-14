suppressPackageStartupMessages(library(adegenet))
suppressPackageStartupMessages(library(dartR))

# Convert Genepop to VCF
# Example input:
# input_file <- "scripts/r_analysis/boot1_combined_JC_JA.gen"
# output_path <- "scripts/r_analysis/"
# out_filename <- "test"

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
    
    # Capture original individual names
    original_names <- adegenet::indNames(gen)
    
    # Convert to genlight (gl)
    gl <- dartR::gi2gl(gen)
    
    # Restore individual names
    adegenet::indNames(gl) <- original_names
    
    # Force everyone into a single dummy population ("AllSamples")
    # This prevents PLINK errors and strips group-level stratification
    adegenet::pop(gl) <- rep("AllSamples", length(original_names))
    
    # Export from gl to VCF 
    dartR::gl2vcf(
      gl, 
      outfile = "intermediate", 
      outpath = output_path, 
      plink_path = dirname(plink_loc)
    )
    
    vcf <- vcfR::read.vcfR(paste0(output_path, "intermediate.vcf"))
    
    # 3. Clean the column names in the genotype slot (@gt)
    # This strips "AllSamples_" from the beginning of any sample name
    colnames(vcf@gt) <- gsub("^AllSamples_", "", colnames(vcf@gt))
    
    # 4. Save the cleaned VCF file back to disk
    vcfR::write.vcf(vcf, file = paste0(output_path, out_filename, ".vcf.gz")) 
    
    # 5. Clean up files
    # Find all matching files
    intermediate_files <- list.files(
      path = output_path, 
      pattern = "^intermediate", 
      full.names = TRUE
    )
    
    plink_output_files <- list.files(
      path = output_path,
      pattern = "^gl_plink",
      full.names = TRUE
    )
    
    file.remove(intermediate_files)
    file.remove(plink_output_files)
}

# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

print(cat("Number of arguments: ", length(args)))

if (length(args) != 3) {
    stop("Usage: genepop_to_vcf <input_vcf_file> <output_path> <out_filename>")
}

genepop_to_vcf(args[1], args[2], args[3])


