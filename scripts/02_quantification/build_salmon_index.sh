#!/bin/bash
# Build Salmon index from Ensembl transcriptome
# Date: Feb 14, 2026
# Working directory: ~/tdp43-dysfunction-score

echo "=========================================="
echo "Building Salmon Index"
echo "Transcriptome: Ensembl GRCh38 r116"
echo "Start: $(date)"
echo "=========================================="

cd ~/tdp43-dysfunction-score

echo ""
echo "Building index with k-mer size 31..."
echo ""

salmon index \
  -t data/references/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i data/references/salmon_index \
  -k 31 \
  --threads 4

echo ""
echo "=========================================="
echo "✓ Salmon index built successfully!"
echo "Location: data/references/salmon_index"
echo "End: $(date)"
echo "=========================================="
