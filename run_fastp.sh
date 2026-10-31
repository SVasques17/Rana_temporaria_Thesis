#!/bin/bash

INPUT_DIR="."
OUTPUT_DIR="fastp_results"

#Quality Parameters
QUALITY=20
WINDOW_SIZE=4
UNQUALIFIED_PERCENT=20
MAX_N=5

#Creating folders
mkdir -p "$OUTPUT_DIR/fastq"
mkdir -p "$OUTPUT_DIR/reports"
mkdir -p "$OUTPUT_DIR/logs"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$OUTPUT_DIR/logs/fastp_${TIMESTAMP}.log"

#Log Function
log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "==============================="
log "Beginning of the fastp analysis"
log "Work folder: $(pwd)"
log "Results folder: $OUTDIR"
log "==============================="

log "FastP Version $(fastp --version 2>&1)"

#Look for R1 files
shopt -s nullglob
R1_FILES=("$INPUT_DIR"/*_R1.fastq.gz)

if [ ${#R1_FILES[@]} -eq 0 ]; then
	log "There are no R1 files."
	exit 1
fi

log "Number of R1 files found: ${#R1_FILES[@]}"

#Counters
SUCCESS=0
FAILED=0

#Process each pair of R1/R2
for R1 in "${R1_FILES[@]}"; do
	#Build the R2 correspondent name
	BASENAME=$(basename "$R1" _R1.fastq.gz)
	R2="$INPUT_DIR/${BASENAME}_R2.fastq.gz"

	if [[ ! -f "$R2" ]]; then
		log "WARNING: The R2 file wasn't found for $BASENAME. Jumping over this pair"
		((FAILED+=1))
		continue
	fi

	OUT_R1="$OUTPUT_DIR/fastq/${BASENAME}_clean_R1.fastq.gz"
	OUT_R2="$OUTPUT_DIR/fastq/${BASENAME}_clean_R2.fastq.gz"

	HTML="$OUTPUT_DIR/reports/${BASENAME}_fastp.html"
	JSON="$OUTPUT_DIR/reports/${BASENAME}_fastp.json"

	log "R1 File: $R1"
	log "R2 File: $R2"
	log "Executing Fastp..."

	if fastp \
		-i "$R1" \
		-I "$R2" \
		-o "$OUT_R1" \
		-O "$OUT_R2" \
		--detect_adapter_for_pe \
		--cut_tail \
		--cut_mean_quality "$QUALITY" \
		--cut_window_size "$WINDOW_SIZE" \
		--qualified_quality_phred "$QUALITY" \
		--unqualified_percent_limit "$UNQUALIFIED_PERCENT" \
		--n_base_limit "$MAX_N" \
		--html "$HTML" \
		--json "$JSON" \
		2>&1 | tee -a "$LOG_FILE"
	then
		log "SUCCESS: $BASENAME sample processed"
		((SUCCESS+=1))
	else
		log "Error in the processing of $BASENAME sample"
		((FAILED+=1))
	fi
done

log "========================================"
log "Analysis concluded. Results in: $OUTDIR"
log "SUCCESS pairs: $SUCCESS"
log "FAILED pairs: $FAILED"
log "Log file: $LOG_FILE"
log "========================================"
