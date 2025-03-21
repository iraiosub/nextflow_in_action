process SEQUENCE_LENGTH {
    tag "$meta.id"

    input:
    tuple val(meta), path(sequences)

    output:
    tuple val(meta), path("*.tsv"), emit: length

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    sequence_length.sh ${sequences} ${prefix}.sequence_length.tsv

    """
}