args = commandArgs(trailingOnly=TRUE)
dataset = args[1]
library(tidyverse)

read_csv(dataset, col_names = T) %>%
  group_by(project, cluster_name) %>%
  summarize(mean = mean(duration), count = n()) %>%
  write_csv(., file="/dev/null")

