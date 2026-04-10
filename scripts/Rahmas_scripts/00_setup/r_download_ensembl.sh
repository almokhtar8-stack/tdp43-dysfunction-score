#!/bin/bash
# Download Ensembl reference files
# Date: March 20, 2026
# Working directory: ~/tdp43-dysfunction-score

echo "=========================================="
echo "Downloading Ensembl GRCh38 References"
echo "Release: 116"
echo "=========================================="

cd ~/tdp43-dysfunction-score

# Create directory
mkdir -p data/references
cd data/references

echo ""
echo "Downloading transcriptome (cDNA)..."
wget https://ftp.ensembl.org/pub/release-116/vertebrates/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz

echo ""
echo "Downloading annotation (GTF)..."
wget https://ftp.ensembl.org/pub/release-116/vertebrates/gtf/homo_sapiens/Homo_sapiens.GRCh38.116.gtf.gz

echo ""
echo "=========================================="
echo "✓ Download complete!"
echo "=========================================="
echo ""
ls -lh Homo_sapiens.GRCh38.*
