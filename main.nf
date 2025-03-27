#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//
// Import modules
//
include { FASTQC } from './modules/nf-core/fastqc'
include { MULTIQC } from './modules/nf-core/multiqc'
include { EXTRACT_SEQUENCE } from './modules/local/extract_sequence'
include { SEQUENCE_LENGTH } from './modules/local/sequence_length'
include { REVERSE_COMPLEMENT } from './modules/local/reverse_complement'
include { MEAN_GC_CONTENT as MEAN_GC_CONTENT_SAMPLE} from './modules/local/mean_gc_content'
include { MEAN_GC_CONTENT as MEAN_GC_CONTENT_ORG} from './modules/local/mean_gc_content'

//
// Define inputs and other parameters (these can also be provided in the nextflow.config file)
//
params.input = file("$projectDir/samplesheet.csv", checkIfExists: true)
params.reverse_complement = false
params.outdir = "results"

//
// Define the main workflow
//
workflow {
    //
    // Create channel from input file provided through params.input
    //
    read_ch = Channel
            .fromPath( params.input )
            .splitCsv(header:true)
            .map { row ->
                def meta = [id: row.sample, org: row.org]
                def reads = file(row.fastq, checkIfExists: true)
                [meta, reads]
        }

    //
    // Create channel for collecting files for MultiQC
    //
    ch_multiqc_files = Channel.empty()

    //
    // Extract sequences from FASTQ files
    //
    EXTRACT_SEQUENCE(read_ch)

    //
    // Run FastQC on raw reads
    //
    FASTQC(read_ch)

    //
    // Get sequence lengths for each FASTQ file
    //
    SEQUENCE_LENGTH(EXTRACT_SEQUENCE.out.sequence)

    //
    // Reverse-complement the sequence if option is enabled
    //
     if (params.reverse_complement) {
        REVERSE_COMPLEMENT(EXTRACT_SEQUENCE.out.sequence)
     }

    //
    // Create ch for caclulating GC content: group sequences by id
    //
    grouped_sequences_by_id = EXTRACT_SEQUENCE.out.sequence
        .map { meta, seq -> [meta.id, seq] }
        .groupTuple(by: [0])

    //
    // Get sequence GC content for each species, using all sequences (from all files) grouped by sample
    //
    MEAN_GC_CONTENT_SAMPLE(grouped_sequences_by_id)

    //
    // Create ch for caclulating GC content: group sequences by org
    //
    grouped_sequences = EXTRACT_SEQUENCE.out.sequence
        .map { meta, seq -> [meta.org, seq] }
        .groupTuple(by: [0])

    //
    // Get sequence GC content for each species, using all sequences grouped by org
    //
    MEAN_GC_CONTENT_ORG(grouped_sequences)

    //
    // Prepare input channel for MultiQC
    //
    ch_fastqc = FASTQC.out.zip
        .map { it[1] }
        .collect()

    ch_multiqc_files = ch_fastqc.mix(ch_multiqc_files)
    // ch_multiqc_files.view { println "MultiQC input: $it" }

    //
    // Call MultiQC with minimal inputs
    //
    MULTIQC (
        ch_multiqc_files,  // This cannot be an empty list
        [],  // multiqc_config
        [],  // extra_multiqc_config
        [],  // multiqc_logo
        [],  // replace_names
        []   // sample_names
    )

}