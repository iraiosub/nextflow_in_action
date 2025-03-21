process EXTRACT_SEQUENCE {
    tag "$meta.id"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.tsv"), emit: sequence

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    extract_sequence.sh ${reads} ${prefix}.sequence.tsv

    """
}