#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//
// Import modules
//
include { FASTQC } from './modules/nf-core/fastqc'
include { EXTRACT_SEQUENCE } from './modules/local/extract_sequence'
include { SEQUENCE_LENGTH } from './modules/local/sequence_length'
include { REVERSE_COMPLEMENT } from './modules/local/reverse_complement'
include { MEAN_GC_CONTENT as MEAN_GC_CONTENT_SAMPLE} from './modules/local/mean_gc_content'
include { MEAN_GC_CONTENT as MEAN_GC_CONTENT_ORG} from './modules/local/mean_gc_content'

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
    // Create a channel for calculating GC content by grouping sequences by id
    //
    grouped_sequences_by_id = EXTRACT_SEQUENCE.out.sequence
        // Restructure each item in the channel:
        // From: [meta (map containing id), seq]
        // To:   [id (extracted from meta), seq]
        .map { meta, seq -> [meta.id, seq] }  // Create a new list with just the id and sequence
        .groupTuple(by: [0])  // The 'by: [0]' means we're grouping based on the first element (index 0) of each item

    //
    // Get sequence GC content for each species, using all sequences (from all files) grouped by sample
    //
    MEAN_GC_CONTENT_SAMPLE(grouped_sequences_by_id)

    //
    // Create a channel for calculating GC content by grouping sequences by org
    //
    grouped_sequences_by_org = EXTRACT_SEQUENCE.out.sequence
        .map { meta, seq -> [meta.org, seq] }
        .groupTuple(by: [0])

    //
    // Get sequence GC content for each species, using all sequences grouped by org
    //
    MEAN_GC_CONTENT_ORG(grouped_sequences_by_org)

}