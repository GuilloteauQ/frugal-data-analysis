args = commandArgs(trailingOnly=TRUE)
dataset = args[1]
library(tidypolars)
library(readr)
library(dplyr)

read_csv(dataset, col_names = T) |>
  as_polars_df() |> 
  group_by(project, cluster_name) |>
  summarize(mean = mean(duration), count = n()) |>
  as_tibble() |>
  write_csv(file="/dev/null")

