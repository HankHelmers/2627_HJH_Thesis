library(tidyverse)

# Get data files
data_folder <- paste0(getwd(), "/data/raw_input/Ebrahimi_5_20_2026_prepared/")
id_data_file <- paste0(data_folder, "sample_map.csv")

# Extract ids from the map file
id_data <- read.csv(file = id_data_file)
id_data <- id_data %>% select(new_name) 

# Extract just each species type
JCs <- id_data %>% filter(str_detect(new_name, "JC"))
JAs <- id_data %>% filter(str_detect(new_name, "JA"))
F1s <- id_data %>% filter(str_detect(new_name, "F1"))
BCs <- id_data %>% filter(str_detect(new_name, "BC"))

# Write them to a output text file 
write.table(JCs, file = paste0(data_folder, "list_JC_IDS.txt"), 
            row.names = FALSE, col.names = FALSE, quote = FALSE)
write.table(JAs, file = paste0(data_folder, "list_JA_IDS.txt"), 
            row.names = FALSE, col.names = FALSE, quote = FALSE)
write.table(F1s, file = paste0(data_folder, "list_F1_IDS.txt"), 
            row.names = FALSE, col.names = FALSE, quote = FALSE)
write.table(BCs, file = paste0(data_folder, "list_BC_IDS.txt"), 
            row.names = FALSE, col.names = FALSE, quote = FALSE)
