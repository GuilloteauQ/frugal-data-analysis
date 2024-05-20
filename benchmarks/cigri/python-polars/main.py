import polars as pl
import sys

dataset = sys.argv[1]

pl.read_csv(dataset).group_by("cluster_name", "project").agg(pl.col("duration").mean(), pl.col("job_id").count()).write_csv("/dev/null")
