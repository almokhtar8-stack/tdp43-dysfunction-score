#!/bin/bash
# Quality Control - FastQC on all samples
# Date: Feb 14, 2026
# Working directory: ~/tdp43-dysfunction-score

echo "=========================================="
echo "Quality Control - FastQC Analysis"
echo "Start: $(date)"
echo "=========================================="

cd ~/tdp43-dysfunction-score

# Create output directory
mkdir -p results/qc/fastqc
mkdir -p results/qc/multiqc

# Input directory
RAW="data/raw"

echo ""
echo "Running FastQC on all 12 FASTQ files..."
echo ""

# Run FastQC on all files
fastqc ${RAW}/*.fastq.gz \
  -o results/qc/fastqc \
  -t 4 \
  --quiet

echo ""
echo "✓ FastQC complete!"
echo ""

# Aggregate with MultiQC
echo "Generating MultiQC report..."
cd results/qc
multiqc fastqc -o multiqc --quiet

echo ""
echo "=========================================="
echo "✓✓✓ QUALITY CONTROL COMPLETE ✓✓✓"
echo "=========================================="
echo ""
echo "Reports generated:"
echo "  - Individual: results/qc/fastqc/"
echo "  - Summary: results/qc/multiqc/multiqc_report.html"
echo ""
echo "End: $(date)"
