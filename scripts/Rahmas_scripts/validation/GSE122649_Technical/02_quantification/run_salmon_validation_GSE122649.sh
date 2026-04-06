#!/bin/bash
# Salmon Quantification for GSE122649 Technical Study

INDEX="/mnt/h/KAUST/tdp43-dysfunction-score/scripts/02_quantification/salmon_index"
FASTQ_DIR="../data/raw"
OUTPUT_DIR="../data/salmon_output"

mkdir -p $OUTPUT_DIR

for fastq in $FASTQ_DIR/*.fastq.gz; do
    sample=$(basename "$fastq" .fastq.gz)
    echo "Quantifying sample: $sample"
    
    salmon quant -i $INDEX -l A         -r $fastq         -p 12 --validateMappings         -o "$OUTPUT_DIR/${sample}_quant"
done
