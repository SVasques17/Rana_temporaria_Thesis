#!/bin/bash

R1="$1"
R2="$2"
OUTDIR="$3"
THREADS="$4"

mkdir -p "$OUTDIR"

fastqc \
	--threads "$THREADS" \
	--outdir "$OUTDIR" \
	"$R1" "$R2"
