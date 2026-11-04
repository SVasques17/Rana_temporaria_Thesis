#!/bin/bash

R1="$1"
R2="$2"

OUT_R1="$3"
OUT_R2="$4"

HTML="$5"
JSON="$6"

THREADS="$7"

mkdir -p "$(dirname "$OUT_R1")"
mkdir -p "$(dirname "$HTML")"

fastp \
	-i "$R1" \
	-I "$R2" \
	-o "$OUT_R1" \
	-O "$OUT_R2" \
	--detect_adapter_for_pe \
	--cut_mean_quality 20 \
	--qualified_quality_phred 20 \
	--unqualified_percent_limit 20 \
	--n_base_limit 5 \
	--html "$HTML" \
	--json "$JSON" \
	--thread "$THREADS"
