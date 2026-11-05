#!/bin/bash

R1="$1"
R2="$2"

OUT_R1="$3"
OUT_R2="$4"

HTML="$5"
JSON="$6"

THREADS="$7"

shift 7
FASTP_OPTIONS=("$@")

mkdir -p "$(dirname "$OUT_R1")"
mkdir -p "$(dirname "$HTML")"

fastp \
	-i "$R1" \
	-I "$R2" \
	-o "$OUT_R1" \
	-O "$OUT_R2" \
	--html "$HTML" \
	--json "$JSON" \
	--thread "$THREADS" \
	"${FASTP_OPTIONS[@]}"
