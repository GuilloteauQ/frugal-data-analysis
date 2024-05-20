BEGIN {
  FS=",";
  OFS=",";
}

NR>1 {
  exec_times[$4,$5] += $6;
  counts[$4,$5]++;
}

END {
  print "project", "cluster", "mean", "count";
  for (group in exec_times) {
    split(group, separate, SUBSEP);
    project = separate[1];
    cluster = separate[2];
    mean = exec_times[group] / counts[group];
    print project, cluster, mean, counts[group];
  }
}
