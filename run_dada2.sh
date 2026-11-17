#!/bin/bash
set -Eeuo pipefail

DEMUX="$1"
TABLE="$2"
REP_SEQS="$3"
STATS="$4"
BASE_STATS="$5"
THREADS="$6"

TRIM_LEFT_F="$7"
TRIM_LEFT_R="$8"
TRUNC_LEN_F="$9"

#Starting the parameters over again

shift 9

TRUNC_LEN_R="$1"
MAX_EE_F="$2"
MAX_EE_R="$3"
TRUNC_Q="$4"

mkdir -p "$(dirname "$TABLE")"

qiime dada2 denoise-paired \
	--i-demultiplexed-seqs "$DEMUX" \
	--p-trim-left-f "$TRIM_LEFT_F" \
	--p-trim-left-r "$TRIM_LEFT_R" \
	--p-trunc-len-f "$TRUNC_LEN_F" \
	--p-trunc-len-r "$TRUNC_LEN_R" \
	--p-max-ee-f "$MAX_EE_F" \
	--p-max-ee-r "$MAX_EE_R" \
	--p-trunc-q "$TRUNC_Q" \
	--p-n-threads "$THREADS" \
	--o-table "$TABLE" \
	--o-representative-sequences "$REP_SEQS" \
	--o-denoising-stats "$STATS" \
	--o-base-transition-stats "$BASE_STATS"

echo "DADA2 completed successfully!"
