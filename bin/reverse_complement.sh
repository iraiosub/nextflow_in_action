#!/bin/sh

# A script to reverse complement sequences from a TSV file (read_name<TAB>sequence)

# Check input
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.tsv output.tsv"
    exit 1
fi

input_tsv="$1"
output_tsv="$2"

# Reverse complement each sequence and write with read name
awk '{
    name = $1
    seq = toupper($2)
    rev = ""
    for (i = length(seq); i > 0; i--) {
        base = substr(seq, i, 1)
        if (base == "A") comp = "T"
        else if (base == "T") comp = "A"
        else if (base == "C") comp = "G"
        else if (base == "G") comp = "C"
        else comp = base
        rev = rev comp
    }
    print name "\t" rev
}' "$input_tsv" > "$output_tsv"

echo "Reverse complements written to: $output_tsv"
