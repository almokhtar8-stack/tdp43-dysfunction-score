#!/bin/bash
# Quantify RNA-seq samples using Salmon for GSE124439
# Date: April 16, 2026
# Path: /mnt/h/KAUST/tdp43-dysfunction-score/scripts/Rahmas_scripts/validation/GSE124439/02_quantification

# Capture overall start time
START_TIME=$(date +%s)
START_DATE=$(date)

echo "=========================================="
echo "Salmon Quantification - GSE124439 Validation"
echo "Overall Start: $START_DATE"
echo "=========================================="

# 1. Define Absolute Paths
PROJECT_DIR="/mnt/h/KAUST/tdp43-dysfunction-score"
BASE_DIR="$PROJECT_DIR/scripts/Rahmas_scripts/validation/GSE124439"
FASTQ_DIR="$BASE_DIR/data/raw"
OUTPUT_DIR="$BASE_DIR/results/salmon"
INDEX="$PROJECT_DIR/data/references/salmon_index"

# Create output directory
mkdir -p $OUTPUT_DIR

# 2. Define Samples
ALS_SAMPLES=("ALS-1" "ALS-2" "ALS-3" "ALS-4" "ALS-5" "ALS-6" "ALS-7" "ALS-8" "ALS-9")
CTRL_SAMPLES=("Control-1" "Control-2" "Control-3" "Control-4" "Control-5" "Control-6" "Control-7" "Control-8" "Control-9")
ALL_SAMPLES=("${ALS_SAMPLES[@]}" "${CTRL_SAMPLES[@]}")

# 3. Execution Loop
for SAMPLE in "${ALL_SAMPLES[@]}"; do
    SAMPLE_START=$(date +%s)
    echo ""
    echo "------------------------------------------"
    echo "Processing: $SAMPLE"
    echo "Start: $(date)"
    echo "------------------------------------------"
    
    salmon quant \
        -i $INDEX \
        -l A \
        -1 ${FASTQ_DIR}/${SAMPLE}_1.fastq.gz \
        -2 ${FASTQ_DIR}/${SAMPLE}_2.fastq.gz \
        -p 8 \
        --validateMappings \
        -o ${OUTPUT_DIR}/${SAMPLE}
    
    SAMPLE_END=$(date +%s)
    DURATION=$((SAMPLE_END - SAMPLE_START))
    echo "✓ $SAMPLE complete in: $((DURATION / 60))m $((DURATION % 60))s"
done

# 4. Final Timing Calculation
END_TIME=$(date +%s)
END_DATE=$(date)
TOTAL_SECONDS=$((END_TIME - START_TIME))

# Convert seconds to H:M:S
H=$((TOTAL_SECONDS / 3600))
M=$(((TOTAL_SECONDS % 3600) / 60))
S=$((TOTAL_SECONDS % 60))

echo ""
echo "=========================================="
echo "✓ All samples quantified successfully!"
echo "Overall Start: $START_DATE"
echo "Overall End:   $END_DATE"
echo "Total Runtime: ${H}h ${M}m ${S}s"
echo "=========================================="
