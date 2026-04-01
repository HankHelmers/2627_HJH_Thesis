# install pophelper dependencies
# install.packages(c("ggplot2","gridExtra","label.switching","tidyr","remotes"),repos="https://cloud.r-project.org")
# install pophelper
# remotes::install_github('royfrancis/pophelper')

# load library for use
library(pophelper)
library(dplyr)
library(purrr)
library(tidyverse)

# example use: https://www.royfrancis.com/pophelper/reference/readQ.html             
sfiles_real <- list.files("STRUCTURE_projects_GUI/aim2_lepais/vaha_primmer_test/Results", full.names=TRUE) 
# list files in current direct
# the below functions need the full path name so full.names = TRUE

# create a qlist of all runs
sfiles_real <- readQ(sfiles_real,filetype="structure")
sfiles_real <- alignK(sfiles_real)

str(sfiles_real[[1]])  # each element = matrix of admixture values


slist_collapsed <- map(sfiles_real, function(run) {
  run_df <- as.data.frame(run)
  # Average every two rows
  run_avg <- run_df %>%
    mutate(row_id = rep(1:(nrow(run_df)/2), each = 2)) %>%
    group_by(row_id) %>%
    summarise(across(everything(), mean))
  run_avg
})



# read in individal tags
structure_input <- read.table("example/3_STRUCTURE_HostExpansion_dryad.srt",
                              sep=" ", quote="", stringsAsFactors=FALSE)
ind_ids <- structure_input[[1]]  # vector of individual IDs
n_inds <- length(ind_ids)



# Make a list of data.frames, one per run
slist_named <- map(sfiles_real, function(run) {
  as.data.frame(run) %>%
    mutate(Individual = ind_ids_expanded) %>%
    relocate(Individual)
})




# get number of runs
run_cols <- grep("^Run_", colnames(agg_df), value = TRUE)
n_runs <- length(run_cols)

error_summary <- data.frame(
  n_reps = integer(),
  mean_error = numeric(),
  sd_error = numeric()
)

for (k in 1:n_runs) {
  
  # Select the first k runs
  runs_k <- run_cols[1:k]
  
  # Mean q estimate across k runs (per individual)
  q_hat <- rowMeans(agg_df[, runs_k, drop = FALSE])
  
  # Error per individual
  epsilon <- agg_df$true_q - q_hat
  
  # Summaries
  mean_eps <- mean(epsilon)
  sd_eps   <- sd(epsilon)
  
  # Store
  error_summary <- rbind(
    error_summary,
    data.frame(
      n_reps = k,
      mean_error = mean_eps,
      sd_error = sd_eps
    )
  )
}

library(ggplot2)

ggplot(error_summary, aes(x = n_reps, y = mean_error)) +
  geom_point(size = 3) +
  geom_line() +
  geom_errorbar(
    aes(
      ymin = mean_error - sd_error,
      ymax = mean_error + sd_error
    ),
    width = 0.2
  ) +
  labs(
    x = "Number of STRUCTURE replicates",
    y = "Mean error (true q − estimated q)",
    title = "Effect of replicate number on admixture average error"
  ) +
  theme_minimal()


ggplot(error_summary, aes(x = n_reps, y = sd_error)) +
  geom_point(size = 3) +
  geom_line() +
  ylim(0, 1) +
  labs(
    x = "Number of STRUCTURE replicates",
    y = "Std. deviation of error (true q − estimated q)",
    title = "Effect of replicate number on admixture variability in error"
  ) +
  theme_minimal()

error_summary <- data.frame(
  n_reps = integer(),
  mean_error = numeric(),
  sd_error = numeric()
)

# hybrid classes
for (k in 1:n_runs) {
  
  runs_k <- run_cols[1:k]
  
  # Mean q across first k runs
  q_hat <- rowMeans(
    agg_df[, runs_k, drop = FALSE]
  )
  
  epsilon <- agg_df$true_q - q_hat
  
  tmp <- agg_df %>%
    mutate(
      n_reps = k,
      epsilon = epsilon
    ) %>%
    group_by(hybrid_class, n_reps) %>%
    summarise(
      mean_error = mean(epsilon),
      sd_error   = sd(epsilon),
      .groups = "drop"
    )
  
  error_summary <- rbind(error_summary, tmp)
}

library(ggplot2)

ggplot(error_summary,
       aes(x = n_reps, y = mean_error, color = hybrid_class)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_errorbar(
    aes(ymin = mean_error - sd_error,
        ymax = mean_error + sd_error),
    width = 0.15,
    alpha = 0.6
  ) +
  theme_minimal() +
  labs(
    x = "Number of STRUCTURE runs averaged",
    y = "Mean error (true q − estimated q)",
    color = "Hybrid class"
  )


ggplot(error_summary,
       aes(x = n_reps, y = sd_error, color = hybrid_class)) +
  geom_line(linewidth = 1) +
  ylim(0, 0.5) + 
  geom_point(size = 2) +
  theme_minimal() +
  labs(
    x = "Number of STRUCTURE runs averaged",
    y = "Std. deviation of error error (true q − estimated q)",
    color = "Hybrid class"
  )

error_summary %>% filter(n_reps <= 4) %>%
  ggplot(aes(x = sd_error)) +
  geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8) +
  ggtitle("Density of all std error readings from 10 runs") +
  theme_minimal() 



agg_df %>% select(1:4) %>% #1-4 is run1
  ggplot(aes(x = Run_1, color=hybrid_class, fill=hybrid_class)) +
  geom_density(alpha=0.8) +
  ggtitle("Density of Run_1 readings") +
  theme_minimal() 



error_summary %>% filter() %>%
  ggplot(aes(x = sd_error, color=hybrid_class, fill=hybrid_class)) +
  geom_density(alpha=0.8) +
  ggtitle("Density of ALL std error readings from 10 runs") +
  theme_minimal() 

error_summary %>% filter(hybrid_class == "F1") %>%
  ggplot(aes(x = sd_error, color=hybrid_class, fill=hybrid_class)) +
  geom_density(alpha=0.8) +
  ggtitle("Density of F1s std error readings from 10 runs") +
  theme_minimal() 

error_summary %>% filter(hybrid_class == "KOKSM") %>%
  ggplot(aes(x = sd_error, color=hybrid_class, fill=hybrid_class)) +
  geom_density(alpha=0.8) +
  ggtitle("Density of KOKSMs std error readings from 10 runs") +
  theme_minimal() 

error_summary %>% filter(hybrid_class == "SOCSM") %>%
  ggplot(aes(x = sd_error, color=hybrid_class, fill=hybrid_class)) +
  geom_density(alpha=0.8) +
  ggtitle("Density of SOCSMs std error readings from 10 runs") +
  theme_minimal() 

