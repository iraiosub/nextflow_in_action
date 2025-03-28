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
            .fromPath( params.input ) // Read the CSV file
            .splitCsv(header:true)    // Parse the CSV, assuming it has a header
            .map { row ->
                // Create a metadata map for each sample
                def meta = [id: row.sample, org: row.org]

                // Get the path to the FASTQ file and check if it exists
                def reads = file(row.fastq, checkIfExists: true)

                // Return a list containing the metadata and the file object
                [meta, reads]
        }

    //
    // Extract sequences from FASTQ files
    //
    EXTRACT_SEQUENCE(read_ch)

}
