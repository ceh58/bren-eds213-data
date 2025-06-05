#!/bin/bash

# Usage:
# ./query_timer.sh label num_reps query db_file csv_file

label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# Add automation
while true; do
    start=$SECONDS
    for _ in $(seq $num_reps); do
        sqlite3 $db_file "$query" >& /dev/null
    done
    end=$SECONDS
    if [ $((end - start)) -gt 5 ]; then
        break
    fi
    echo "Too fast, trying again!"
    num_reps=$((num_reps * 10))
done

# Get start time in seconds
start_time=$(date +%s)

# Run the query num_reps times
for i in $(seq "$num_reps"); do
    sqlite3 "$db_file" "$query" > /dev/null
done

# Get end time
end_time=$(date +%s)

# Compute elapsed time in seconds
elapsed=$((end_time - start_time))

# Compute average time per query
avg_time=$(echo "scale=6; $elapsed / $num_reps" | bc)

# Extract number of distinct values
if [ "$label" = "none" ]; then
  num_distinct=$(sqlite3 "$db_file" "SELECT COUNT(*) FROM ($query) AS a")
else
  distinct="SELECT COUNT(*) FROM (
    SELECT DISTINCT $label FROM Bird_nests
  ) AS a"
  num_distinct=$(sqlite3 "$db_file" "$distinct")
fi

# Write results to CSV (append mode)
echo "\"$label\",$avg_time,$num_distinct" >> "$csv_file"
