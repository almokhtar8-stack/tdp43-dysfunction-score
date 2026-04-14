#!/bin/bash
# Quality Control - FastQC and MultiQC
# Project: GSE124439 Validation (ALS vs Control)
# Author: Rahma Abufoor
# Date: April 14, 2026

echo "=========================================="
echo "Quality Control - FastQC Analysis"
echo "Start: $(date)"
echo "=========================================="

# Define the Master Project Path
BASE_DIR="/mnt/h/KAUST/tdp43-dysfunction-score/scripts/Rahmas_scripts/validation/GSE124439"
RAW_DATA="$BASE_DIR/data/raw"
QC_OUT="$BASE_DIR/results/qc/fastqc"
MULTIQC_OUT="$BASE_DIR/results/qc/multiqc"

# Create output directories
mkdir -p "$QC_OUT"
mkdir -p "$MULTIQC_OUT"

echo "Checking for 36 FASTQ files in $RAW_DATA..."

# Run FastQC
# -t 4: Uses 4 CPU threads simultaneously (4x faster)
# -o: Sends output to our organized results folder
fastqc "$RAW_DATA"/*.fastq.gz \
    -o "$QC_OUT" \
    -t 4 \
    --quiet

echo "✓ FastQC individual reports complete!"

# Aggregate with MultiQC
echo "Generating MultiQC summary report..."
multiqc "$QC_OUT" -o "$MULTIQC_OUT" -n GSE124439_summary_report.html --quiet

echo ""
echo "=========================================="
echo "✓✓✓ QUALITY CONTROL COMPLETE ✓✓✓"
echo "=========================================="
echo "Individual Reports: $QC_OUT"
echo "Summary Report: $MULTIQC_OUT/GSE124439_summary_report.html"
echo "End: $(date)"
