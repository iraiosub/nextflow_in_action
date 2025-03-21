process REVERSE_COMPLEMENT {
    tag "$meta.id"

    input:
    tuple val(meta), path(sequences)

    output:
    tuple val(meta), path("*.tsv"), emit: reverse_complement

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    reverse_complement.sh ${sequences} ${prefix}.reverse_complement.tsv

    """
}