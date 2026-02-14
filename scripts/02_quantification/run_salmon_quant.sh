#!/bin/bash
# Quantify RNA-seq samples using Salmon
# Date: Feb 14, 2026
# Working directory: ~/tdp43-dysfunction-score

echo "=========================================="
echo "Salmon Quantification - 6 Samples"
echo "Start: $(date)"
echo "=========================================="

cd ~/tdp43-dysfunction-score

# Create output directory
mkdir -p results/salmon

# Sample arrays
KO_SAMPLES=("SRR10045016" "SRR10045017" "SRR10045018")
RESCUE_SAMPLES=("SRR10045019" "SRR10045020" "SRR10045021")

# Combine arrays
ALL_SAMPLES=("${KO_SAMPLES[@]}" "${RESCUE_SAMPLES[@]}")

# Quantify each sample
for SAMPLE in "${ALL_SAMPLES[@]}"; do
    echo ""
    echo "=========================================="
    echo "Processing: $SAMPLE"
    echo "Start: $(date)"
    echo "=========================================="
    
    salmon quant \
        -i data/references/salmon_index \
        -l A \
        -1 data/raw/${SAMPLE}_1.fastq.gz \
        -2 data/raw/${SAMPLE}_2.fastq.gz \
        -p 4 \
        --validateMappings \
        -o results/salmon/${SAMPLE}
    
    echo ""
    echo "✓ $SAMPLE complete: $(date)"
    echo ""
done

echo ""
echo "=========================================="
echo "✓ All samples quantified successfully!"
echo "End: $(date)"
echo "=========================================="
