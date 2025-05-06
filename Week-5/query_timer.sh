#!/bin/bash

# Usage:
# ./query_timer.sh label num_reps query db_file csv_file

label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# Get start time in nanoseconds
start_time=$(date +%s%N)

# Run the query num_reps times
for ((i = 1; i <= num_reps; i++)); do
    duckdb "$db_file" "$query" > /dev/null
done

# Get end time
end_time=$(date +%s%N)

# Compute elapsed time in seconds
elapsed_ns=$((end_time - start_time))
elapsed_s=$(echo "$elapsed_ns / 1000000000" | bc -l)

# Compute average time per query
avg_time=$(echo "$elapsed_s / $num_reps" | bc -l)

# Write results to CSV (append mode)
echo "$label,$num_reps,$elapsed_s,$avg_time" >> "$csv_file"
