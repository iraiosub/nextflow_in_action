#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Import modules: nf-core
include { FASTQC } from './modules/nf-core/fastqc'
include { MULTIQC } from './modules/nf-core/multiqc'

// Import modules: local
include { EXTRACT_SEQUENCE } from './modules/local/extract_sequence'


// Define inputs and other parameters (these can also be provided in the nextflow.config file)
params.input = "samplesheet.csv"
params.reverse_complement = false
params.outdir = "results"

// Define the main workflow
workflow {
    // Create channel for input reads
    read_ch = Channel
            .fromPath( params.input )
            .splitCsv(header:true)
            .map { row ->
                def meta = [id: row.sample, org: row.org]
                def reads = file(row.fastq, checkIfExists: true)
                [meta, reads]
        }

    // Run FastQC on raw reads
    FASTQC(read_ch)

    // Extract sequences from FASTQ files
    EXTRACT_SEQUENCE(read_ch)

    // Get sequence lengths for each FASTQ file
    CALCULATE_SEQUENCE_LENGTH(UMI_TOOLS_EXTRACT.out.sequence)

    // Reverse-complement the sequence if option is enabled
     if (params.single_end) {
        REVERSE_COMPLEMENT(CALCULATE_SEQUENCE_LENGTH.out.sequence)
     }

    // NEEDS UPDATING Get sequence GC content for each species, using all sequences (from all files) grouped by org
    SUMMARISE_GC_CONTENT(CALCULATE_SEQUENCE_LENGTH.out.sequence)

    // NEEDS UPDATING Run MultiQC

    // Collect FastQC outputs
    ch_multiqc_files = FASTQC.out.html.collect()

    // Call MultiQC with minimal inputs
    MULTIQC (
        ch_multiqc_files,  // This cannot be an empty list
        [],  // multiqc_config
        [],  // extra_multiqc_config
        [],  // multiqc_logo
        [],  // replace_names
        []   // sample_names
    )

}