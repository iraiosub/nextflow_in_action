#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//
// Import modules
//
include { EXTRACT_SEQUENCE } from './modules/local/extract_sequence'

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
    // Extract sequences from FASTQ files
    //
    EXTRACT_SEQUENCE(read_ch)

}
