process MEAN_GC_CONTENT {
    tag "$meta.id"

    input:
    tuple val(meta), path(sequences)

    output:
    tuple val(meta), path("*.tsv"), emit: mean_gc_content

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mean_gc_content.sh ${prefix} ${sequences} > ${prefix}.mean_gc_content.tsv

    """
}