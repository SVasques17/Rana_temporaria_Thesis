# Introduction of the Project
Scripts used for my thesis project on the metagenomic 16S amplicon analysis of Rana temporaria gut microbiota of two populations: one from northern Spain and another from northern Sweden

# Installing
``git clone https://github.com/SVasques17/Rana_temporaria_Thesis.git``

# Configuration File 
There will be a main file with a menu where it will be possible to do all the pipeline in simple steps. However, it isn't completly ready at this stage of the project.

## 1. Quality Control
At this stage, I created the *run_fastqc.sh* script to analyse the quality of the .fastqc files that are in the same folder. After that, it's possible to run the multiqc command to compile all the quality control report files on one single file.
After that, with the *run_fastp.sh* script I also created, the user can fix any errors or take out any less quality sequences part of the sample as they see fit.
In the end of the quality control phase, the *run_fastqc.sh* script should be run again as well as the multiqc command to verify if the quality improved.
