#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//
// Import modules
//
include { FASTQC } from './modules/nf-core/fastqc'
include { EXTRACT_SEQUENCE } from './modules/local/extract_sequence'
include { SEQUENCE_LENGTH } from './modules/local/sequence_length'
include { REVERSE_COMPLEMENT } from './modules/local/reverse_complement'

//
// Define inputs and other parameters (these can also be provided in the nextflow.config file)
//
params.input = file("$projectDir/samplesheet.csv", checkIfExists: true)

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


}