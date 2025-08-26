#!/bin/bash

logdir="/data/logs"
output="/data/cgi.csv"

# List of log files (expandable)
logfiles=("teapot.log" "deathscreen.log" "style.log")

# Get current timestamp
timestamp=$(date -d "1 minute ago" +"%F %H:%M")

# Initialize array with timestamp
row=("$timestamp")

# Loop through log files and count lines (assuming each line is a timestamp entry)
for logfile in "${logfiles[@]}"; do
    count=$(wc -l < "$logdir/$logfile")
    row+=("$count")
done

# Output to CSV
(
    IFS=;
    echo "${row[*]}"
) >> "$output"