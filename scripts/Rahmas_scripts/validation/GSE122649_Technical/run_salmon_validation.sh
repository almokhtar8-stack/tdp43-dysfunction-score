#!/bin/bash

# 1. Define ONLY Human Samples
SAMPLES=(
  SRR8263595 SRR8263596 SRR8263597 SRR8263598 
  SRR8263599 SRR8263600 SRR8263601 SRR8263602 
  SRR8263603 SRR8263604 SRR8263605 SRR8263606
)

# 2. Define Absolute Paths (To avoid "File Not Found" errors)
BASE_DIR="/mnt/h/KAUST/tdp43-dysfunction-score/scripts/Rahmas_scripts/validation/GSE122649_Technical"
FASTQ_DIR="$BASE_DIR/data/raw"
OUTPUT_DIR="$BASE_DIR/results/salmon"
INDEX="/mnt/h/KAUST/tdp43-dysfunction-score/data/references/salmon_index"

mkdir -p $OUTPUT_DIR

echo "=========================================================="
echo "Starting Validation Quant for ${#SAMPLES[@]} HUMAN samples"
echo "=========================================================="

for SRR in "${SAMPLES[@]}"; do
    echo "Processing: $SRR"

    # Verify files exist in the absolute path
    if [[ -f "$FASTQ_DIR/${SRR}_1.fastq.gz" ]]; then
        
        salmon quant -i $INDEX \
         -l A \
         -1 $FASTQ_DIR/${SRR}_1.fastq.gz \
         -2 $FASTQ_DIR/${SRR}_2.fastq.gz \
         -p 12 --validateMappings \
         -o $OUTPUT_DIR/${SRR}_quant

    else
        echo "ERROR: Could not find $FASTQ_DIR/${SRR}_1.fastq.gz"
    fi
done
