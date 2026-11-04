#!/bin/bash

INPUT_DIR="$1"
OUTPUT_DIR="$2"
REPORT_NAME="$3"

mkdir -p "$OUTPUT_DIR"

multiqc "$INPUT_DIR" \
	--outdir "$OUTPUT_DIR" \
	--filename "$REPORT_NAME" \
	--force
