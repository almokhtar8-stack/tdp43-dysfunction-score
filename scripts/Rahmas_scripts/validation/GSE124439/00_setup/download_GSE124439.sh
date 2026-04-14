#!/bin/bash
# SRA Download Script - GSE124439 Validation Data
# Date: April 11, 2026
# Project: tdp43-dysfunction-score
# Optimized with pigz and clean naming conventions

echo "=========================================="
echo "GSE124439 Validation Data Download"
echo "Start: $(date)"
echo "=========================================="

# Set Working Directory
cd /mnt/h/KAUST/tdp43-dysfunction-score/scripts/Rahmas_scripts/validation/GSE124439/
mkdir -p data/raw
cd data/raw

# 9 Controls and 9 ALS Samples
SAMPLES=(
  "SRR8375282" "SRR8375326" "SRR8375310" "SRR8375373" "SRR8375369" 
  "SRR8375384" "SRR8375382" "SRR8375381" "SRR8375375"
  "SRR8375274" "SRR8375275" "SRR8375276" "SRR8375277" "SRR8375278" 
  "SRR8375279" "SRR8375280" "SRR8375283" "SRR8375284"
)

NAMES=(
  "Control-1" "Control-2" "Control-3" "Control-4" "Control-5" 
  "Control-6" "Control-7" "Control-8" "Control-9"
  "ALS-1" "ALS-2" "ALS-3" "ALS-4" "ALS-5" 
  "ALS-6" "ALS-7" "ALS-8" "ALS-9"
)

for i in "${!SAMPLES[@]}"; do
  SRR=${SAMPLES[$i]}
  NAME=${NAMES[$i]}

  echo ""
  echo "=========================================="
  echo "Sample $((i+1))/18: $SRR ($NAME)"
  echo "=========================================="

  # Check if the RENAMED files already exist to skip
  if [ -f "${NAME}_1.fastq.gz" ] && [ -f "${NAME}_2.fastq.gz" ]; then
    echo "✓ $NAME already exists, skipping..."
    continue
  fi

  echo "  [1/4] Prefetching..."
  prefetch $SRR

  echo "  [2/4] Converting to FASTQ..."
  fasterq-dump --split-3 --threads 4 --progress $SRR

  # Rename the raw fastq files immediately after dumping
  mv ${SRR}_1.fastq ${NAME}_1.fastq
  mv ${SRR}_2.fastq ${NAME}_2.fastq

  echo "  [3/4] Compressing with pigz..."
  pigz -p 4 ${NAME}_1.fastq ${NAME}_2.fastq

  echo "  [4/4] Cleanup..."
  rm -rf ~/ncbi/public/sra/${SRR}.sra
  rm -rf ${SRR}

  echo "✓ $NAME Complete!"
done

echo ""
echo "=========================================="
echo "✓✓✓ VALIDATION DATASET READY ✓✓✓"
echo "End: $(date)"
echo "=========================================="
