#!/bin/bash
# Download complete genome-wide RNA-seq data
# Working directory: ~/tdp43-dysfunction-score

echo "=========================================="
echo "TDP-43 Complete Genome Download"
echo "Total: 6 samples (~25GB)"
echo "Working in: $(pwd)"
echo "=========================================="

# Navigate to project and create raw data directory

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
  echo "=========================================="
  
  # Skip if exists
  if [ -f "${SRR}_1.fastq.gz" ] && [ -f "${SRR}_2.fastq.gz" ]; then
    echo "✓ Already downloaded, skipping"
    continue
  fi
  
  # Download (fast method)
  echo "  1/4 Prefetching..."
  prefetch $SRR
  
  echo "  2/4 Converting to FASTQ..."
  fasterq-dump --split-files --threads 4 --progress $SRR
  
  echo "  3/4 Compressing..."
  gzip ${SRR}_1.fastq ${SRR}_2.fastq
  
  echo "  4/4 Cleaning up..."
  rm -rf ~/ncbi/public/sra/${SRR}.sra
  
  echo "✓ $SRR complete"
done

echo ""
echo "=========================================="
echo "✓✓✓ ALL DOWNLOADS COMPLETE ✓✓✓"
echo "=========================================="
echo ""
echo "Downloaded files:"
ls -lh *.fastq.gz

echo ""
echo "Total size:"
du -sh .
