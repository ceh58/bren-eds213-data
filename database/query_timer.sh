#!/bin/bash

# Usage:
# ./query_timer.sh label num_reps query db_file csv_file

label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# Get start time in nanoseconds
start_time=$(date +%s)

# Run the query num_reps times
for i in $(seq "$num_reps"); do
    duckdb "$db_file" "$query" > /dev/null
done

# Get end time
end_time=$(date +%s)

# Compute elapsed time in seconds
elapsed=$((end_time - start_time))

# Compute average time per query
avg_time=$(echo "scale=6; $elapsed / $num_reps" | bc)

# Write results to CSV (append mode)
echo "$label,$num_reps,$avg_time" >> "$csv_file"
