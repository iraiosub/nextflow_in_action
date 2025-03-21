#!/bin/sh

# A script to extract read names (only the ERR* part) and sequences from a FASTQ file and output them as TSV

# Check input
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.fastq output.tsv"
    exit 1
fi

input_fastq="$1"
output_tsv="$2"

# Extract simplified read names and sequences
awk 'NR % 4 == 1 { split($1, id, "@"); name = id[2] } NR % 4 == 2 { print name "\t" $0 }' "$input_fastq" > "$output_tsv"

echo "Extracted read names and sequences to: $output_tsv"