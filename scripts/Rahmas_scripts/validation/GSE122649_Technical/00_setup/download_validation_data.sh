#!/bin/bash

# 1. Define the samples
SAMPLES=(SRR8263595 SRR8263596 SRR8263597 SRR8263598 SRR8263599 SRR8263600 SRR8263601 SRR8263602 SRR8263603 SRR8263604 SRR8263605 SRR8263606 SRR8263607 SRR8263608 SRR8263609 SRR8263610 SRR8263611 SRR8263612 SRR8263613 SRR8263614 SRR8263615 SRR8263616 SRR8263617 SRR8263618 SRR8263619 SRR8263620 SRR8263621 SRR8263622 SRR8263623 SRR8263624 SRR8263625 SRR8263626)

# 2. Set the directory
OUT_DIR="../data/raw"
mkdir -p $OUT_DIR
cd $OUT_DIR

# 3. Loop through samples with status bars
TOTAL=${#SAMPLES[@]}
COUNT=0

for sra in "${SAMPLES[@]}"; do
    COUNT=$((COUNT + 1))
    echo "-------------------------------------------------------"
    echo " Sample $COUNT of $TOTAL: $sra in progress"
    echo "-------------------------------------------------------"
    
    echo "Step 1: Prefetching $sra..."
    prefetch $sra
    
    echo "Step 2: Extracting Fastq files..."
    fasterq-dump $sra --threads 12 --progress
    
    echo "Step 3: Compressing (Gzip)..."
    gzip ${sra}*.fastq
    
    echo "-------------------------------------------------------"
    echo " Finished $sra. Moving to next..."
    echo ""
done

echo "======================================================="
echo " SUCCESS: All $TOTAL samples are downloaded successfully! "
echo "======================================================="
