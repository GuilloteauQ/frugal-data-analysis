import pandas as pd
import sys

dataset = sys.argv[1]

pd.read_csv(dataset).groupby(["cluster_name", "project"]).agg({'duration': 'mean', 'job_id': 'count'}).to_csv("/dev/null")
