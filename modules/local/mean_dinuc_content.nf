process MEAN_DINUC_CONTENT {
    tag "$group_key"

    input:
    tuple val(group_key), path(sequences)

    output:
    tuple val(group_key), path("*.tsv"), emit: mean_gc_content

    script:
    def args          = task.ext.args ?: ''

    """
    mean_dinucleotide_content.sh ${group_key} ${args} ${sequences} > ${group_key}.mean_${args}_content.tsv
    """
}