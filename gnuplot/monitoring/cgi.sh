#!/bin/bash

logdir="/data/logs"
output="/data/cgi.csv"

# List of log files (expandable)
logfiles=("teapot.log" "deathscreen.log" "style.log")

# Get current timestamp
timestamp=$(date -u -d "5 minutes ago" +"%F %H:00")

# Initialize array with timestamp
row=("$timestamp")

# Loop through log files and count lines (assuming each line is a timestamp entry)
for logfile in "${logfiles[@]}"; do
    if test -e $logdir/$logfile; then
        count=$(wc -l < "$logdir/$logfile")
        count=$(echo "$count / 60" | bc -l)
    else
        count=0
    fi
    row+=("$count")
    rm "$logdir/$logfile"
done

# Output to CSV
(
    IFS=';'
    echo "${row[*]}"
) >> "$output"
