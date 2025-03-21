#!/bin/sh

# A script to calculate sequence lengths from a TSV file (read_name<TAB>sequence)
# and output read_name + length as TSV

# Check input
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.tsv output.tsv"
    exit 1
fi

input_tsv="$1"
output_tsv="$2"

# Read input TSV and calculate sequence length
awk '{
    name = $1
    seq = $2
    print name "\t" length(seq)
}' "$input_tsv" > "$output_tsv"

echo "Sequence lengths written to: $output_tsv"
