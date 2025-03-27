process MEAN_GC_CONTENT {
    tag "$group_key"

    input:
    tuple val(group_key), path(sequences)

    output:
    tuple val(group_key), path("*.tsv"), emit: mean_gc_content

    script:
    """
    mean_gc_content.sh ${group_key} ${sequences} > ${group_key}.mean_gc_content.tsv
    """
}