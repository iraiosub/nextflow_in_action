#!/bin/sh

# A script to calculate mean GC content from any number of TSVs (read_name<TAB>sequence)
# Outputs a TSV with headers: sample and GC%

# Check input
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 sample_id input1.tsv [input2.tsv ...]"
    exit 1
fi

sample_id="$1"
shift  # Remove the first argument so "$@" becomes the list of input files

# Combine all inputs and calculate mean GC content
cat "$@" | awk -v sample="$sample_id" '
BEGIN {
    print "Sample\tGC"
}
{
    seq = toupper($2)
    len = length(seq)
    gc = 0
    for (i = 1; i <= len; i++) {
        base = substr(seq, i, 1)
        if (base == "G" || base == "C") gc++
    }
    total_gc += gc
    total_bases += len
}
END {
    if (total_bases > 0) {
        mean_gc = total_gc / total_bases * 100
        printf "%s\t%.2f\n", sample, mean_gc
    } else {
        printf "%s\tNA\n", sample
    }
}'
