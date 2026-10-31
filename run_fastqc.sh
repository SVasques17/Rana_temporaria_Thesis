#!/bin/bash

#Folder to save the resulting quality control reports
OUTDIR="qc_before_fastp"
LOGDIR="$OUTDIR/logs"

mkdir -p "$OUTDIR" "$LOGDIR"

#Creating a single log per execution with date
LOGFILE="$LOGDIR/fastqc_$(date +%Y%m%d_%H%M%S).log"

#Function to register messages in the terminal and in the log
log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

log "==========================================="
log "Beginning of the FastQC Analysis"
log "Work folder: $(pwd)"
log "Results folder: $OUTDIR"
log "==========================================="

log "FastQC Version: $(fastqc --version 2>&1)"

#Look for R1 files
shopt -s nullglob

r1_files=( *_R1*.fastq.gz )

if [ ${#r1_files[@]} -eq 0 ]; then
	log "There are no R1 files."
	exit 1
fi

log "Number of R1 files found: ${#r1_files[@]}"

#Counters
SUCCESS=0
FAILED=0
MISSING=0

#Process each pair of R1/R2
for R1 in "${r1_files[@]}"; do
	#BUild the R2 correspondent name
	R2="${R1%_R1.fastq.gz}_R2.fastq.gz"

	if [ -f "$R2" ]; then
		log "Analyzing $R1 and $R2"

		if fastqc -o "$OUTDIR" "$R1" "$R2" 2>&1 | tee -a "$LOGFILE"; then
			log "SUCESSO: ${R1%R1.fastq.gz}"
			((SUCCESS++))
		else
			log "ERROR: FastQC failed in ${R1%_R1.fastq.gz}"
			((FAILED++))
		fi

	else
		log "WARNING: The pair of R1 wasn't found"
		((MISSING++))
	fi

done

log "===================================="
log "Analysis concluded. Results in: $OUTDIR"
log "SUCCESS pairs: $SUCCESS"
log "FAILED pairs: $FAILED"
log "Log file: $LOGFILE"
log "===================================="
