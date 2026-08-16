library(tidyverse)
library(ggplot2)

input_trace_file <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_05_26_26_vcf_to_nh_JC_data_trace_pi/newhybrids_3_subsampled_top10_loci200_20260526/NewHybridsLog_Trace1.txt"

out_dir <- "/work/williarj/williarj/2627_HJH_Thesis/experiment_outputs/output_05_26_26_vcf_to_nh_JC_data_trace_pi/newhybrids_3_subsampled_top10_loci200_20260526/"

# Read lines from File
input_lines <- readLines(input_trace_file)

# Get only the lines with data in them
data_lines <- grep("PI_TRACE:", input_lines, value=TRUE)

# Remove the data indicator text
data_lines <- sub("PI_TRACE:", "", data_lines)

# Split each row into a dataframe
df <- read_tsv(
  paste(data_lines, collapse = "\n"),
  show_col_types = FALSE
)

line_plot <- ggplot(data=df, aes(x=Rep, y=Pure_1))
line_plot <- line_plot + geom_point(aes(color=Pure_1))
line_plot <- line_plot + theme_minimal()

ggsave(
        filename = file.path(out_dir, "trace.png"),
        plot = line_plot
    )
