library(reshape2)
library(ggplot2)

# Example input
# 5
# run_folder <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_04_07_26_generalizing_algo_runs/newhybrids/run"
# output_path <- "/work/williarj/williarj/2627_HJH_Thesis/experiments/04_08_26_visualizing_structure"
# 

visualize_nh_ggplot <- function(total_num_runs, run_folder, output_path) {
    run_num <- 1

    for (run_num in 1:total_num_runs) {
        results_file <- nh_results_folder <- paste0(run_folder, "/run", run_num, "/aa-PofZ.txt")

        df <- read.table(results_file, header = TRUE)

        colnames(df) <- c("sweep","Individual","F1","Pop1","Pop2")

        df_long <- melt(df, id.vars = c("sweep","Individual"))

        out <- ggplot(df_long, aes(x = Individual, y = value, fill = variable)) +
        geom_bar(stat = "identity") +
        coord_flip() +
        theme_bw() +
        labs(fill = "Ancestry class")

        ggsave(
                filename = file.path(output_path, paste0("run", run_num, ".png")),
                plot = out
            )
    }
}


# ---- CLI entry point
args <- commandArgs(trailingOnly = TRUE)

print(length(args))

if (length(args) != 3) {
    stop("Usage: visualize_nh_ggplot.R <total_num_runs> <run_folder> <output_path>")
}

visualize_nh_ggplot(as.numeric(args[1]), args[2], args[3])

