args = commandArgs(trailingOnly=TRUE)
dataset = args[1]
library(polars)

pl$scan_csv(
    dataset
)$group_by(
    "project", "cluster_name"
)$agg(
    pl$col("duration")$mean(),
    pl$col("job_id")$count()
)$collect()$write_csv("/dev/null")

