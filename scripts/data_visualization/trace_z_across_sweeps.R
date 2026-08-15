library(tidyverse)
library(ggplot2)

input_trace_file <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_05_26_26_vcf_to_nh_JC_data_trace_z/newhybrids_3_subsampled_top10_loci200_scharmann_20260527/NewHybridsLog_Trace1.txt"

out_dir <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_05_26_26_vcf_to_nh_JC_data_trace_z/newhybrids_3_subsampled_top10_loci200_scharmann_20260527/"

# Read lines from File
input_lines <- readLines(input_trace_file)

# Get only the lines with data in them
data_lines <- grep("Z_TRACE:", input_lines, value=TRUE)

# Remove the top line which tells what the categories mean
data_lines <- data_lines[-1]

# Remove the data indicator text
data_lines <- sub("Z_TRACE:", "", data_lines)

# Split each row into a dataframe
df <- read_tsv(
  paste(data_lines, collapse = "\n"),
  show_col_types = FALSE
)

df <- df %>% filter(IndIdx==4)

# Category: "Z_TRACE:# Categories (first is 0): F1 Pure_1 Pure_0 "

line_plot <- ggplot(data=df, aes(x=Rep, y=Z))
line_plot <- line_plot + geom_point(aes(color=Z))
line_plot <- line_plot + theme_minimal()

ggsave(
        filename = file.path(out_dir, "trace.png"),
        plot = line_plot
    )
