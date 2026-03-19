#!/bin/bash
# Run Salmon quantification on all 6 samples
# Working directory: ~/tdp43-dysfunction-score


INDEX="data/references/salmon_index"
RAW="data/raw"
OUT="data/salmon_output"

mkdir -p $OUT

SAMPLES=(SRR10045016 SRR10045017 SRR10045018 SRR10045019 SRR10045020 SRR10045021)
NAMES=("KO-1" "KO-2" "KO-3" "Rescue-1" "Rescue-2" "Rescue-3")

for i in "${!SAMPLES[@]}"; do
  SRR=${SAMPLES[$i]}
  NAME=${NAMES[$i]}
  
  echo "=========================================="
  echo "Quantifying: $SRR ($NAME)"
  echo "=========================================="
  
  salmon quant \
    -i $INDEX \
    -l A \
    -1 ${RAW}/${SRR}_1.fastq.gz \
    -2 ${RAW}/${SRR}_2.fastq.gz \
    -p 4 \
    --validateMappings \
    -o ${OUT}/${SRR}
  
  echo "✓ $SRR quantified"
done

echo ""
echo "✓✓✓ All samples quantified ✓✓✓"
echo "Output directory: $OUT"
