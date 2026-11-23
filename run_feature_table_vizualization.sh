#!/bin/bash
set -Eeuo pipefail

TABLE="$1"
FEATURE_FREQ="$2"
SAMPLE_FREQ="$3"
SUMMARY="$4"

mkdir -p "$(dirname "$SUMMARY")"

qiime feature-table summarize \
	--i-table "$TABLE" \
	--o-feature-frequencies "$FEATURE_FREQ" \
	--o-sample-frequencies "$SAMPLE_FREQ" \
	--o-summary "$SUMMARY"

echo "Feature table sumamry completed successfully."
echo "Now the feature table can be visualized."
