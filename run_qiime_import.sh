#!/bin/bash

set -Eeuo pipefail

# Declaring the input and output files
## input
MANIFEST="$1"
## output
DEMUX="$2"
SUMMARY="$3"

# Creating the output directory
mkdir -p "$(dirname "$DEMUX")"
mkdir -p "$(dirname "$SUMMARY")"

# Importing paired-end FASTQ files into QIIME2
qiime tools import \
    --type 'SampleData[PairedEndSequencesWithQuality]' \
    --input-path "$MANIFEST" \
    --output-path "$DEMUX" \
    --input-format PairedEndFastqManifestPhred33V2

# Generating quality summary visualization
qiime demux summarize \
    --i-data "$DEMUX" \
    --o-visualization "$SUMMARY"

echo "QIIME2 import and quality summary completed successfully."
