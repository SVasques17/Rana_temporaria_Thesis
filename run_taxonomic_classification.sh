#!/bin/bash
set -Eeuo pipefail

REP_SEQS="$1"
CLASSIFIER="$2"
TAXONOMY="$3"
CONFIDENCE="$4"
THREADS="$5"

mkdir -p "$(dirname "$TAXONOMY")"

qiime feature-classifier classify-sklearn \
	--i-reads "$REP_SEQS" \
	--i-classifier "$CLASSIFIER" \
	--p-confidence "$CONFIDENCE" \
	--p-n-jobs "$THREADS" \
	--o-classification "$TAXONOMY"

echo "Taxonomic classification completed successfully."
