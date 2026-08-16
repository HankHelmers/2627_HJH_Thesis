library(ggplot2)
library(dplyr)
library(readr)

generate_pca_plots <- function(pca_eigenvec_file, pca_eigenval_file, out_dir, pc, color_input, experiment_name) {
    print(paste0("Creating plot for PCs: ", pc))
    
    # read in from files
    pca <- read_table(pca_eigenvec_file, col_names = FALSE)
    eigenval <- scan(pca_eigenval_file)

    # ---- Clean PCA data
    # remove nuisance column
    pca <- pca[,-1]
    # set column names
    names(pca)[1] <- "ind"
    names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

    print(pca[1])

    # first convert to percentage variance explained
    pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)

    # ---- Variance explained plot
    # Visualize the amount of variance explained by each PC 
    a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity") + ylab("Percentage variance explained") + theme_light() + theme(text = element_text(size = 20)) 
    a

    pc_to_graph_1 <- paste0("PC", pc)
    pc_to_graph_2 <- paste0("PC", pc+1)

    # ---- PCA scatter plot
    b <- ggplot(pca, aes(
        x = .data[[pc_to_graph_1]],
        y = .data[[pc_to_graph_2]])) 
    b <- b + geom_point(size = 3, color = color_input) + coord_equal()
    b <- b + theme_light() + theme(text=element_text(size = 20))
    b <- b + labs(
        title=experiment_name,
        x = paste0("PC", pc, " (", signif(pve$pve[pc], 3), "%)"),
        y = paste0("PC", pc+1, " (", signif(pve$pve[pc+1], 3), "%)")
        )
    b

    ggsave(
        filename = file.path(out_dir, paste0(experiment_name, "_variance_per_pca.png")),
        plot = a
    )

    ggsave(
        filename = file.path(out_dir, paste0(experiment_name, "_PC_", pc, "_", pc+1, "_pca.png")),
        plot = b
    )
}

# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 6) {
    stop("Usage: script.R <eigenvec> <eigenval> <out_dir> <pc> <color_input> <experiment_name>")
}

generate_pca_plots(args[1], args[2], args[3], as.numeric(args[4]), args[5], args[6])