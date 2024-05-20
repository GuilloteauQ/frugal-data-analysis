#!/bin/bash

script=$1
dataset=$2
benchmark=$3
lang=$4

time_before=$(date +%s.%N)
python3 $script $dataset
time_after=$(date +%s.%N)

echo $benchmark, $lang, $time_before, $time_after
