# Introduction of the Project
Scripts used for my thesis project on the metagenomic 16S amplicon analysis of Rana temporaria gut microbiota of two populations: one from northern Spain and another from northern Sweden

# Installing
``git clone https://github.com/SVasques17/Rana_temporaria_Thesis.git``

# Warnings & Notes
This *README* will only touch upon what is necessary to do for a single population. If there's more than one population being analysed, each population should have a separate folder.

# Configuration File 
The file named *Snakefile* will be the only one that should be looked into if there is some parameter that needs to be altered.

## 1. Quality Control
With the main s, I created the *run_fastqc.sh* script to analyse the quality of the .fastqc files that are in the same folder. After that, it's possible to run the multiqc command to compile all the quality control report files on one single file.
After that, with the *run_fastp.sh* script I also created, the user can fix any errors or take out any less quality sequences part of the sample as they see fit.
In the end of the quality control phase, the *run_fastqc.sh* script should be run again as well as the multiqc command to verify if the quality improved.
