#!/bin/bash

binary=$1
dataset=$2
benchmark=$3
lang=$4

time_before=$(date +%s.%N)
./$binary $dataset /dev/null
time_after=$(date +%s.%N)

echo $benchmark, $lang, $time_before, $time_after
