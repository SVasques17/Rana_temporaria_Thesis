# Introduction of the Project
Scripts used for my thesis project on the metagenomic 16S amplicon analysis of Rana temporaria gut microbiota of two populations: one from northern Spain and another from northern Sweden

# Installing
```text
git clone https://github.com/SVasques17/Rana_temporaria_Thesis.git
```

# Warnings & Notes
This *README* will only touch upon what is necessary to do for a single population. If there's more than one population being analysed, each population should have a separate folder.

# Main File and Configuration File 
The file named *Snakefile* will be the main file to run when executing this pipeline.

If there are so parameters to be changed, they should be altered in the *config.yaml* file. The several flags of the Fastp used in the *run_fastp.sh* script are all descriminated there and can be changed as the user sees fit.   

# Before Running
## Different Environments
To be able to run this project, there are some things that should already be installed on the user's Linuc command line:

**-->** Snakemake conda environment. If it is not installed, the next command will install it:

```text
conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake
```

**-->** Two other conda environments: a conda environment that is comprised of FastQC, FastP and MultiQC; and another one that has QIIME2 installed. If they are not already installed, the next commands will install them:

```text
conda create -c conda-forge -c bioconda -c nodefaults -n qc_pipeline fastqc fastp multiqc
```

```text
conda env create --name rachis-qiime-2026.7 --file https://raw.githubusercontent.com/qiime2/distributions/dev/2026.7/amplicon/released/qiime2-amplicon-ubuntu-latest-conda.yml
```
(*Example of the 2026.7 version*) 

## Folder Structure
The main folder structure is:
```text
PopulationName/
├── raw_data/
├── results/
├── scripts/
└── logs/
```
The logs/ and results/ folders are created by the *Snakefile* and the scripts, **however** inside the main folder, there needs to be already a raw_data/ folder (with all the .fastq.gz raw files) and a scripts/ folder (with all the scripts done to be used by the *Snakefile*).

## Scripts
### run_fastqc.sh
This script does the first part of the quality control phase of the analysis. It's main goal is to gather quality control reports about every *.fastq.gz* file.

### run_multiqc.sh
In this script, the files created by the last script are aggregated into a single file to be easier to verify the quality of the *.fastq.gz* files.

### run_fastp.sh
In this last part of quality control, all the errors and other artifacts present in the *.fastq.gz* files can be corrected.

# How to Run
To verify the integrity of every file and if everything will run smoothly, first the user should run the following command:
```text
snakemake -n
```
After that, if there are no error, to finally execute the pipeline, the user should run:
```text
snakemake --cores 8
```
