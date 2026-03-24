.libPaths("~/local/bin/Rlibs")

library(ggplot2)
library(dplyr)
library(readr)

generate_pca_plots <- function(pca_eigenvec_file, pca_eigenval_file, out_dir, experiment_name) {
    # read in from files
    pca <- read_table(pca_eigenvec_file)
    eigenval <- scan(pca_eigenval_file)

    # ---- Clean PCA data
    # remove nuisance column
    pca <- pca[,-1]
    # set column names
    names(pca)[1] <- "ind"
    names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

    # first convert to percentage variance explained
    pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)

    # ---- Variance explained plot
    # Visualize the amount of variance explained by each PC 
    a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity") + ylab("Percentage variance explained") + theme_light() + theme(text = element_text(size = 20))
    a

    # ---- PCA scatter plot
    b <- ggplot(pca, aes(PC1, PC2)) + geom_point(size = 3)
    b <- b + scale_colour_manual(values = c("red", "blue")) + coord_equal() + theme_light() 
    b <- b + theme(text=element_text(size = 20))
    b <- b + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)"))  
    b <- b + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
    b

    ggsave(
        filename = file.path(out_dir, paste0(experiment_name, "_variance_per_pca.png")),
        plot = a
    )

    ggsave(
        filename = file.path(out_dir, paste0(experiment_name, "_pca.png")),
        plot = b
    )
}

# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
    stop("Usage: script.R <eigenvec> <eigenval> <experiment_name> <out_dir>")
}

generate_pca_plots(args[1], args[2], args[3], args[4])
