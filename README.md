# "Nextflow in Action: Design and Implement Your Own Bioinformatics Workflows" workshop


## Project Structure:

```plaintext
nextflow_in_action/
├── .nextflow/                # Internal Nextflow runtime metadata (created automatically)
├── bin/                      # Shell scripts used by processes (e.g., for sequence extraction or stats)
│   ├── extract_sequence.sh
│   ├── mean_gc_content.sh
│   ├── reverse_complement.sh
│   └── sequence_length.sh
├── conf/                     # Configuration files for the pipeline
│   └── modules.config        # Module-specific config overrides (e.g., custom publishDir)
├── data/                     # Input FASTQ files for testing or running the pipeline
│   ├── human_1.fastq
│   ├── human_2.fastq
│   ├── mouse_1.fastq
│   └── mouse_2.fastq
├── modules/                  # Nextflow modules, both custom and nf-core
│   ├── local/                # Custom local modules written in DSL2 (`.nf` files)
│   │   ├── extract_sequence.nf
│   │   ├── reverse_complement.nf
│   │   └── sequence_length.nf
│   └── nf-core/              # nf-core compatible modules (e.g., fastqc, multiqc)
│       ├── fastqc/
│       └── multiqc/
├── .gitignore                # Git ignored files
├── .nf-core.yml              # nf-core metadata and linting configuration
├── main.nf                   # Main pipeline script (entry point)
├── modules.json              # nf-core module registry (for reproducibility)
├── nextflow.config           # Global Nextflow configuration (params, profiles, etc.)
├── README.md                 # You're reading it! Description of the project and structure
└── samplesheet.csv           # Sample metadata used as input to the pipeline
```