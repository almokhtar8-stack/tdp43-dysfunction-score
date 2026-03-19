#!/bin/bash
# Build Salmon index from Ensembl transcriptome
# Working directory: ~/tdp43-dysfunction-score


echo "Building Salmon index..."

salmon index \
  -t data/references/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i data/references/salmon_index \
  -k 31 \
  --threads 4

echo "✓ Salmon index built at: data/references/salmon_index"
