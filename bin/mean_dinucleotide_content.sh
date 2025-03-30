#!/bin/sh
# A script to calculate mean GC or AT content from any number of TSVs (read_name<TAB>sequence)
# Outputs a TSV with headers: sample and either GC% or AT%
# Check input
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 sample_id content_type input1.tsv [input2.tsv ...]"
    echo "content_type: gc or at (case insensitive)"
    exit 1
fi

sample_id="$1"
content_type=$(echo "$2" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase
shift 2  # Remove the first two arguments so "$@" becomes the list of input files

# Validate content_type
if [ "$content_type" != "gc" ] && [ "$content_type" != "at" ]; then
    echo "Error: content_type must be either 'gc' or 'at'"
    exit 1
fi

# Set header based on content type
if [ "$content_type" = "gc" ]; then
    header="GC"
else
    header="AT"
fi

# Combine all inputs and calculate mean content
cat "$@" | awk -v sample="$sample_id" -v content_type="$content_type" -v header="$header" '
BEGIN {
    print "Sample\t" header
}
{
    seq = toupper($2)
    len = length(seq)
    count = 0
    for (i = 1; i <= len; i++) {
        base = substr(seq, i, 1)
        if (content_type == "gc" && (base == "G" || base == "C")) count++
        if (content_type == "at" && (base == "A" || base == "T")) count++
    }
    total_count += count
    total_bases += len
}
END {
    if (total_bases > 0) {
        mean_content = total_count / total_bases * 100
        printf "%s\t%.2f\n", sample, mean_content
    } else {
        printf "%s\tNA\n", sample
    }
}'