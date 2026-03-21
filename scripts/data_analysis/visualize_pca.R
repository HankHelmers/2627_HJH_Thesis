.libPaths("~/local/bin/Rlibs")

library(ggplot2)
library(dplyr)
library(readr)

# project_root <- "2627_HJH_Thesis/experiments/03_21_26_ebrahimi_data_prep"

# read in data
pca <- read_table(file.path("pca_linkage_pruned", "pca_linkage_pruned.eigenvec"), col_names = FALSE)
eigenval <- scan(file.path("pca_linkage_pruned", "pca_linkage_pruned.eigenval"))

generate_pca_plots <- function(pca, eigenval, experiment_name) {
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
    ggsave(paste0("variance_per_PC_",experiment_name,".png"), plot = a)

    # ---- PCA scatter plot
    b <- ggplot(pca, aes(PC1, PC2)) + geom_point(size = 3)
    b <- b + scale_colour_manual(values = c("red", "blue")) + coord_equal() + theme_light() 
    b <- b + theme(text=element_text(size = 20))
    b <- b + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)"))  
    b <- b + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
    b

    ggsave(paste0("pca_",experiment_name,".png"), plot = b)
}

generate_pca_plots(pca, eigenval, "linkage_pruned")
