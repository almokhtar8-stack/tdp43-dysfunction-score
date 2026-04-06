#!/bin/bash
# Script to download Technical Validation data (GSE122649) 
# Target: 32 samples from SRA

OUT_DIR="../data/raw"
mkdir -p $OUT_DIR

# List of Accession numbers (Example snippet of your 32 samples)
SAMPLES=("SRR8263596" "SRR8263597" "SRR8263598" "SRR8263599" "SRR8263600")

for sra in "${SAMPLES[@]}"; do
    echo "Downloading $sra..."
    prefetch $sra -O $OUT_DIR
    fasterq-dump $sra --outdir $OUT_DIR --threads 12 --progress
    gzip $OUT_DIR/$sra*.fastq
done
