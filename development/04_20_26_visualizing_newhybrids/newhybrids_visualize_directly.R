# CONDA ENV

options(repos = c(CRAN = "https://cloud.r-project.org"))

#install.packages("reshape2")

library(reshape2)
library(ggplot2)

run_num <- 1

for (run_num in 1:5) {
    results_file <- nh_results_folder <- paste0("/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs/newhybrids/run", run_num, "/aa-PofZ.txt")

    df <- read.table(results_file, header = TRUE)

    colnames(df) <- c("sweep","Individual","F1","Pop1","Pop2")

    df_long <- melt(df, id.vars = c("sweep","Individual"))

    out <- ggplot(df_long, aes(x = Individual, y = value, fill = variable)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    theme_bw() +
    labs(fill = "Ancestry class")

    ggsave(
            filename = file.path("/work/williarj/williarj/2627_HJH_Thesis/experiments/04_08_26_visualizing_structure", paste0("run", run_num, ".png")),
            plot = out
        )
}

