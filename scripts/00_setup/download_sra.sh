#!/bin/bash
# SRA Download Script - Complete Genome Data
# Date: Feb 14, 2026

echo "=========================================="
echo "TDP-43 Complete Genome Download"
echo "Start: $(date)"
echo "=========================================="

cd ~/tdp43-dysfunction-score
mkdir -p data/raw
cd data/raw

SAMPLES=(SRR10045016 SRR10045017 SRR10045018 SRR10045019 SRR10045020 SRR10045021)
NAMES=("KO-1" "KO-2" "KO-3" "Rescue-1" "Rescue-2" "Rescue-3")

for i in "${!SAMPLES[@]}"; do
  SRR=${SAMPLES[$i]}
  NAME=${NAMES[$i]}
  
  echo ""
  echo "=========================================="
  echo "Sample $((i+1))/6: $SRR ($NAME)"
  echo "Time: $(date +%H:%M:%S)"
  echo "=========================================="
  
  if [ -f "${SRR}_1.fastq.gz" ] && [ -f "${SRR}_2.fastq.gz" ]; then
    echo "✓ Already downloaded"
    continue
  fi
  
  echo "  [1/4] Prefetching..."
  prefetch $SRR
  
  echo "  [2/4] Converting to FASTQ..."
  fasterq-dump --split-files --threads 4 --progress $SRR
  
  echo "  [3/4] Compressing..."
  gzip ${SRR}_1.fastq ${SRR}_2.fastq
  
  echo "  [4/4] Cleanup..."
  rm -rf ~/ncbi/public/sra/${SRR}.sra
  
  echo "✓ Complete!"
done

echo ""
echo "=========================================="
echo "✓✓✓ ALL DOWNLOADS COMPLETE ✓✓✓"
echo "End: $(date)"
echo "=========================================="
ls -lh *.fastq.gz
du -sh .
