### Using conda/mamba
Anaconda is available via module load. If you prefer to manage your own conda/mamba installation you can follow my steps here:
-   Download the install script `wget https://github.com/conda-forge/miniforge/releases/download/23.3.1-1/Mambaforge-23.3.1-1-Linux-x86_64.sh`
-   Give script execute permissions `chmod 755 Mambaforge-23.3.1-1-Linux-x86_64.sh`
-   Execute install script `./Mambaforge-23.3.1-1-Linux-x86_64.sh`
-   When prompted for install location, give a folder **in your scratch user folder**, eg. `/scratch/prj/ppn_rnp_networks/users/charlotte.capitanchik/software/mambaforge` If you give an RDS location then you won't be able to use conda on the compute nodes.
-   When prompted whether or not to initialise after installation, select yes. If you didn't initialise at the time, you can load conda on HPC with `ml anaconda3` and then run `conda init` command. 
-   Move `.conda` folder from the home folder location to somewhere you have more space in scratch, `mv .conda /scratch/prj/ppn_rnp_networks/users/charlotte.capitanchik/software/mambaforge/.conda`
-   Then soft link `.conda` in your home directory to the scratch user folder eg. `ln -s /scratch/prj/ppn_rnp_networks/users/charlotte.capitanchik/software/mambaforge/.conda .conda`
-   then `ls -la` to check it’s correct
-   `source .bashrc` to initialise first time

Following these instructions mamba and all your envs will be available to you on the compute nodes.

### Using Nextflow
-   Make a mamba environment for Nextflow runs: `mamba create -n nf -c conda-forge -c bioconda nextflow nf-core nf-test`
-   Note on KCL CREATE singularity is only available on compute nodes, so you **must** run your pipeline with sbatch or from within an interactive job ie. `srun -p cpu --pty /bin/bash` followed by `mamba activate nf`
-   In the activated environment you can run Nextflow pipelines, test it out by running the test RNA-Seq data: `nextflow run nf-core/rnaseq -c create.config -profile test,singularity --outdir .`
-   Check that Nextflow is correctly sending jobs to slurm by looking at your submitted jobs in the queue `squeue -u k123467` replace with your k number.
-   The create.config comes from here: https://github.com/nf-core/configs/blob/master/conf/create.config if it doesn't pull in automatically you can copy and paste the config into a file in your CREATE space.
-   Whenever you run Nextflow, Singularity will be your container engine, ensure you provide the `create.config` and `-profile singularity` every time.
