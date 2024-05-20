#!/bin/bash

dataset=$1
script=$2
here=$(pwd)

time_before=$(date +%s.%N)
awk -f $script $dataset
time_after=$(date +%s.%N)

echo $time_before, $time_after
