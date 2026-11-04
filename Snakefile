import os
from snakemake.io import glob_wildcards

# Defining the names of the folders
RAW = "raw_data"
RESULTS = "results"
LOGS = "logs"
SCRIPTS = "scripts"

THREADS = 4

# Gathering the R1 samples automatically
SAMPLES = glob_wildcards(RAW + "/{sample}_R1.fastq.gz").sample

# Creating the necessary folders
## The raws and scripts respective folders must be already present at the same level as this file
os.makedirs(RESULTS, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

# Defining the final results files in the folders in the RESULTS directory
## MultiQC
rule all:
	input:
		RESULTS + "/multiqc_before/multiqc_before_fastp.html",
		RESULTS + "/multiqc_after/multiqc_after_fastp.html"

## FastQC before cleaning with FastP
rule fastqc_before:
	input:
		R1 = RAW + "/{sample}_R1.fastq.gz",
		R2 = RAW + "/{sample}_R2.fastq.gz"

	output:
		RESULTS + "/fastqc_before/{sample}_R1_fastqc.zip",
		RESULTS + "/fastqc_before/{sample}_R2_fastqc.zip"

	log:
		LOGS + "/fastqc_before/{sample}.log"

	threads: THREADS

	shell:
		"""
		mkdir -p "$(dirname {log:q})"
		conda run --no-capture-output -n qc_pipeline \
			bash {SCRIPTS}/run_fastqc.sh \
			{input.R1:q} {input.R2:q} \
			{RESULTS}/fastqc_before {threads} \
			> {log:q} 2>&1
		"""

## MultiQC before FastP
rule multiqc_before:
	input:
		expand(
			RESULTS + "/fastqc_before/{sample}_{read}_fastqc.zip",
			sample=SAMPLES,
			read=["R1", "R2"]
		)

	output:
		RESULTS + "/multiqc_before/multiqc_before_fastp.html"

	log:
		LOGS + "/multiqc_before.log"

	shell:
		"""
		mkdir -p "$(dirname {log:q})"
		conda run --no-capture-output -n qc_pipeline \
			bash {SCRIPTS}/run_multiqc.sh \
			{RESULTS}/fastqc_before \
			{RESULTS}/multiqc_before \
			multiqc_before_fastp.html \
			> {log:q} 2>&1
		"""

## FastP Cleanup
rule fastp:
	input:
		R1 = RAW + "/{sample}_R1.fastq.gz",
		R2 = RAW + "/{sample}_R2.fastq.gz"

	output:
		R1 = RESULTS + "/fastp/{sample}_R1_clean.fastq.gz",
		R2 = RESULTS + "/fastp/{sample}_R2_clean.fastq.gz",
		HTML = RESULTS + "/fastp/{sample}_fastp.html",
		JSON = RESULTS + "/fastp/{sample}_fastp.json"

	log:
		LOGS + "/fastP/{sample}.log"

	threads: THREADS

	shell:
		"""
		mkdir -p "$(dirname {log:q})"
		conda run --no-capture-output -n qc_pipeline \
			bash {SCRIPTS}/run_fastp.sh \
			{input.R1:q} {input.R2:q} \
			{output.R1:q} {output.R2:q} \
			{output.HTML:q} {output.JSON:q} \
			{threads} \
			> {log:q} 2>&1
		"""

## FastQC after cleaning with FastP
rule fastqc_after:
	input:
		R1 = RESULTS + "/fastp/{sample}_R1_clean.fastq.gz",
		R2 = RESULTS + "/fastp/{sample}_R2_clean.fastq.gz"

	output:
		RESULTS + "/fastqc_after/{sample}_R1_clean_fastqc.zip",
		RESULTS + "/fastqc_after/{sample}_R2_clean_fastqc.zip"

	log:
		LOGS + "/fastqc_after/{sample}.log"

	threads: THREADS

	shell:
		"""
		mkdir -p "$(dirname {log:q})"
		conda run --no-capture-output -n qc_pipeline \
			bash {SCRIPTS}/run_fastqc.sh \
			{input.R1:q} {input.R2:q} \
			{RESULTS}/fastqc_after {threads} \
			> {log:q} 2>&1
		"""

## MultiQC before FastP
rule multiqc_after:
	input:
		expand(
			RESULTS + "/fastqc_after/{sample}_{read}_clean_fastqc.zip",
			sample=SAMPLES,
			read=["R1", "R2"]
		)

	output:
		RESULTS + "/multiqc_after/multiqc_after_fastp.html"

	log:
		LOGS + "/multiqc_after.log"

	shell:
		"""
		mkdir -p "$(dirname {log:q})"
		conda run --no-capture-output -n qc_pipeline \
			bash {SCRIPTS}/run_multiqc.sh \
			{RESULTS}/fastqc_after \
			{RESULTS}/multiqc_after \
			multiqc_after_fastp.html \
			> {log:q} 2>&1
		"""
