#!/bin/sh

# A scipt to extract sequences from a FASTQ file

# Check if a file is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.fastq output.txt"
    exit 1
fi

input_fastq="$1"
output_txt="$2"

# Extract sequences (every 2nd line) and save to output file
awk 'NR % 4 == 2' "$input_fastq" > "$output_txt"