# Genome-Wide TDP-43 Analysis Workflow

**Project:** TDP-43 Dysfunction Score - ML-Based Early Detection  
**Date Started:** February 2026  
**Analysis Type:** Complete genome-wide RNA-seq (chr1-22, X including chr11)  
**Working Directory:** ~/tdp43-dysfunction-score

---

## Phase 1: Setup & Data Download

### 1.1 System Check
```bash
# Navigate to project
cd ~/tdp43-dysfunction-score

# Check disk space (need 30GB+)
df -h ~

# Activate environment
conda activate genomics

# Verify tools
fastq-dump --version
salmon --version
```


**Status:** ☑ Complete  
**Date:** Feb 14, 2026  
**Notes:** 92GB available, SRA toolkit 3.2.1, Salmon 1.10.3

---

### 1.2 Download Ensembl References
```bash
# Navigate to project
cd ~/tdp43-dysfunction-score

# Create directory
mkdir -p data/references
cd data/references

# Download transcriptome (cDNA)
wget https://ftp.ensembl.org/pub/release-116/vertebrates/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz

# Download annotation (GTF)
wget https://ftp.ensembl.org/pub/release-116/vertebrates/gtf/homo_sapiens/Homo_sapiens.GRCh38.116.gtf.gz

# Verify
ls -lh
```

**Files to check:**
- ☑ Homo_sapiens.GRCh38.cdna.all.fa.gz (175M)
- ☑ Homo_sapiens.GRCh38.116.gtf.gz (135M)

**Status:** ☑ Complete  
**Date:** Feb 14, 2026  
**Notes:** Both files downloaded successfully


---

### 1.3 Create tx2gene Mapping

**Create script:** `scripts/00_setup/create_tx2gene.R`
```bash
cd ~/tdp43-dysfunction-score
mkdir -p scripts/00_setup
nano scripts/00_setup/create_tx2gene.R
```

**Paste:**
```r
#!/usr/bin/env Rscript
# Create transcript-to-gene mapping
# Working directory: ~/tdp43-dysfunction-score

library(GenomicFeatures)

cat("Creating tx2gene mapping...\n")

# Create TxDb from GTF
txdb <- makeTxDbFromGFF("data/references/Homo_sapiens.GRCh38.116.gtf.gz")

# Extract mapping
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, keys = k, columns = "GENEID", keytype = "TXNAME")

# Remove version numbers
tx2gene$GENEID <- gsub("\\..*", "", tx2gene$GENEID)
tx2gene$TXNAME <- gsub("\\..*", "", tx2gene$TXNAME)
tx2gene <- unique(tx2gene)

# Save
saveRDS(tx2gene, "data/references/tx2gene.rds")
write.csv(tx2gene, "data/references/tx2gene.csv", row.names = FALSE)

cat("✓ Created tx2gene with", nrow(tx2gene), "transcripts\n")
cat("✓ Unique genes:", length(unique(tx2gene$GENEID)), "\n")
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
Rscript scripts/00_setup/create_tx2gene.R
```

**Status:** ☑ Complete  
**Date:** Feb 14, 2026  
**Transcripts:** 646,577  
**Genes:** 78,941  

---

### 1.4 Download SRA Data (Complete Genome)

**Create script:** `scripts/00_setup/download_sra.sh`
```bash
cd ~/tdp43-dysfunction-score
nano scripts/00_setup/download_sra.sh
```

**Paste:**
```bash
#!/bin/bash
# Download complete genome-wide RNA-seq data
# Working directory: ~/tdp43-dysfunction-score

echo "=========================================="
echo "TDP-43 Complete Genome Download"
echo "Total: 6 samples (~25GB)"
echo "Working in: $(pwd)"
echo "=========================================="

# Navigate to project and create raw data directory
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
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
chmod +x scripts/00_setup/download_sra.sh
bash scripts/00_setup/download_sra.sh
```

**Expected files (12 total):**
- ☑ SRR10045016_1.fastq.gz, SRR10045016_2.fastq.gz (KO-1)
- ☑ SRR10045017_1.fastq.gz, SRR10045017_2.fastq.gz (KO-2)
- ☑ SRR10045018_1.fastq.gz, SRR10045018_2.fastq.gz (KO-3)
- ☑ SRR10045019_1.fastq.gz, SRR10045019_2.fastq.gz (Rescue-1)
- ☑ SRR10045020_1.fastq.gz, SRR10045020_2.fastq.gz (Rescue-2)
- ☑ SRR10045021_1.fastq.gz, SRR10045021_2.fastq.gz (Rescue-3)

**Status:** ☑ Complete  
**Date:** Feb 14, 2026  
**Download time:** 5 hours 10 minutes (02:23 - 07:33)  
**Total size:** 67GB  

---

### 1.5 Verify Downloads
```bash
cd ~/tdp43-dysfunction-score/data/raw

# Count files (should be 12)
ls -1 *.fastq.gz | wc -l

# List all files
ls -lh *.fastq.gz

# Check total size
du -sh .
```

**Status:** ☑ Complete  
**File count:** 12  
**Total size:** 67GB  

---

### 1.6 Commit Phase 1 to GitHub
```bash
cd ~/tdp43-dysfunction-score

git add scripts/00_setup/
git add docs/genome_wide_workflow.md
git commit -m "Phase 1 complete: downloaded complete genome data and references

- Downloaded 6 SRA samples (SRR10045016-21)
- Downloaded Ensembl GRCh38 r116 references
- Created tx2gene mapping
- Ready for Salmon quantification"
git push origin main
```

**Status:** ☑ Complete
**Date:** Feb 14, 2026

---

## Phase 2: Salmon Quantification

### 2.1 Build Salmon Index

**Create script:** `scripts/02_quantification/build_salmon_index.sh`
```bash
cd ~/tdp43-dysfunction-score
mkdir -p scripts/02_quantification
nano scripts/02_quantification/build_salmon_index.sh
```

**Paste:**
```bash
#!/bin/bash
# Build Salmon index from Ensembl transcriptome
# Working directory: ~/tdp43-dysfunction-score

cd ~/tdp43-dysfunction-score

echo "Building Salmon index..."

salmon index \
  -t data/references/Homo_sapiens.GRCh38.cdna.all.fa.gz \
  -i data/references/salmon_index \
  -k 31 \
  --threads 4

echo "✓ Salmon index built at: data/references/salmon_index"
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
chmod +x scripts/02_quantification/build_salmon_index.sh
bash scripts/02_quantification/build_salmon_index.sh
```

**Status:** ☐ Complete  
**Date:**  
**Time taken:**  

---

### 2.2 Quantify All Samples

**Create script:** `scripts/02_quantification/run_salmon.sh`
```bash
cd ~/tdp43-dysfunction-score
nano scripts/02_quantification/run_salmon.sh
```

**Paste:**
```bash
#!/bin/bash
# Run Salmon quantification on all 6 samples
# Working directory: ~/tdp43-dysfunction-score

cd ~/tdp43-dysfunction-score

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
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
chmod +x scripts/02_quantification/run_salmon.sh
bash scripts/02_quantification/run_salmon.sh
```

**Status:** ☐ Complete  
**Date:**  
**Time taken:**  

---

### 2.3 Commit Phase 2
```bash
cd ~/tdp43-dysfunction-score

git add scripts/02_quantification/
git add docs/genome_wide_workflow.md
git commit -m "Phase 2 complete: Salmon quantification - genome-wide counts ready"
git push origin main
```

**Status:** ☐ Complete

---

## Phase 3: Differential Expression Analysis

### 3.1 Import and Combine Data

**Create script:** `scripts/03_differential_expression/import_data.R`
```bash
cd ~/tdp43-dysfunction-score
nano scripts/03_differential_expression/import_data.R
```

**Paste:**
```r
#!/usr/bin/env Rscript
# Import Salmon quantifications with tximport
# Working directory: ~/tdp43-dysfunction-score

library(tximport)

cat("Importing Salmon quantifications...\n")

# Load tx2gene
tx2gene <- readRDS("data/references/tx2gene.rds")

# Find quant files
files <- list.files("data/salmon_output", 
                    pattern = "quant.sf", 
                    recursive = TRUE,
                    full.names = TRUE)
names(files) <- basename(dirname(files))

cat("Found", length(files), "quantification files\n")

# Import
txi <- tximport(files, type = "salmon", tx2gene = tx2gene)

# Save
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
saveRDS(txi, "data/processed/genome_wide_txi.rds")

cat("\n✓ Import complete!\n")
cat("  Genes:", nrow(txi$counts), "\n")
cat("  Samples:", ncol(txi$counts), "\n")
cat("  Saved to: data/processed/genome_wide_txi.rds\n")
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
Rscript scripts/03_differential_expression/import_data.R
```

**Status:** ☐ Complete  
**Date:**  
**Genes:**  
**Samples:**  

---

### 3.2 Run DESeq2

**Create script:** `scripts/03_differential_expression/run_deseq2.R`
```bash
cd ~/tdp43-dysfunction-score
nano scripts/03_differential_expression/run_deseq2.R
```

**Paste:**
```r
#!/usr/bin/env Rscript
# Genome-wide differential expression analysis
# Working directory: ~/tdp43-dysfunction-score

library(DESeq2)

cat("Running genome-wide DESeq2 analysis...\n\n")

# Load data
txi <- readRDS("data/processed/genome_wide_txi.rds")

# Sample metadata
coldata <- data.frame(
  condition = factor(c("KO", "KO", "KO", "Rescue", "Rescue", "Rescue")),
  row.names = c("SRR10045016", "SRR10045017", "SRR10045018",
                "SRR10045019", "SRR10045020", "SRR10045021")
)

# Create DESeq object
dds <- DESeqDataSetFromTximport(txi, colData = coldata, design = ~ condition)

# Filter low counts
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]

cat("Analyzing", nrow(dds), "genes...\n")

# Run DESeq2
dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "KO", "Rescue"))

# Get significant DEGs
sig <- res[!is.na(res$padj) & res$padj < 0.05 & abs(res$log2FoldChange) >= 1, ]

# Save
saveRDS(dds, "data/processed/dds_genome_wide.rds")
saveRDS(res, "data/processed/results_genome_wide.rds")

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)
write.csv(as.data.frame(res), "results/tables/all_genes_results.csv")
write.csv(as.data.frame(sig), "results/tables/significant_degs.csv")

# Get normalized counts for ML
norm_counts <- counts(dds, normalized = TRUE)
write.csv(norm_counts, "results/tables/normalized_counts.csv")

# Summary
cat("\n✓ DESeq2 Analysis Complete\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("Total genes analyzed:", nrow(dds), "\n")
cat("Significant DEGs:", nrow(sig), "\n")
cat("  Upregulated in KO:", sum(sig$log2FoldChange > 0), "\n")
cat("  Downregulated in KO:", sum(sig$log2FoldChange < 0), "\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━\n")
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
Rscript scripts/03_differential_expression/run_deseq2.R
```

**Status:** ☐ Complete  
**Date:**  
**Total genes:**  
**Significant DEGs:**  
**Upregulated:**  
**Downregulated:**  

---

### 3.3 Commit Phase 3
```bash
cd ~/tdp43-dysfunction-score

git add scripts/03_differential_expression/
git add results/tables/significant_degs.csv
git add docs/genome_wide_workflow.md
git commit -m "Phase 3 complete: genome-wide DESeq2 analysis - X DEGs identified"
git push origin main
```

**Status:** ☐ Complete

---

## Phase 4: Visualization

**Create script:** `scripts/04_visualization/create_plots.R`
```bash
cd ~/tdp43-dysfunction-score
nano scripts/04_visualization/create_plots.R
```

**Paste:**
```r
#!/usr/bin/env Rscript
# Create publication-quality figures
# Working directory: ~/tdp43-dysfunction-score

library(DESeq2)
library(ggplot2)
library(pheatmap)

cat("Creating visualizations...\n")

# Load results
dds <- readRDS("data/processed/dds_genome_wide.rds")
res <- readRDS("data/processed/results_genome_wide.rds")

dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)

# 1. Volcano plot
cat("  Creating volcano plot...\n")
volcano_data <- as.data.frame(res)
volcano_data$significant <- ifelse(
  !is.na(volcano_data$padj) & volcano_data$padj < 0.05 & abs(volcano_data$log2FoldChange) >= 1,
  "Significant", "Not Significant"
)

p_volcano <- ggplot(volcano_data, aes(x = log2FoldChange, y = -log10(padj), color = significant)) +
  geom_point(alpha = 0.5, size = 1) +
  scale_color_manual(values = c("gray", "red")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") +
  theme_bw() +
  labs(title = "Genome-Wide Differential Expression (TDP-43 KO vs Rescue)",
       x = "Log2 Fold Change",
       y = "-Log10 Adjusted P-value")

ggsave("results/figures/volcano_plot.png", p_volcano, width = 10, height = 8, dpi = 300)

# 2. MA plot
cat("  Creating MA plot...\n")
png("results/figures/ma_plot.png", width = 3000, height = 2400, res = 300)
plotMA(res, ylim = c(-5, 5), main = "MA Plot - Genome-Wide")
dev.off()

# 3. PCA plot
cat("  Creating PCA plot...\n")
vsd <- vst(dds, blind = FALSE)
png("results/figures/pca_plot.png", width = 3000, height = 2400, res = 300)
plotPCA(vsd, intgroup = "condition") +
  theme_bw() +
  ggtitle("PCA - Genome-Wide Expression")
dev.off()

# 4. Heatmap
cat("  Creating heatmap...\n")
top_genes <- head(order(res$padj), 50)
mat <- assay(vsd)[top_genes, ]
mat <- mat - rowMeans(mat)

png("results/figures/heatmap_top50.png", width = 3000, height = 4000, res = 300)
pheatmap(mat,
         annotation_col = as.data.frame(colData(dds)[, "condition", drop = FALSE]),
         show_rownames = TRUE,
         cluster_cols = TRUE,
         main = "Top 50 DEGs - Genome-Wide")
dev.off()

cat("\n✓ All plots created!\n")
cat("  Location: results/figures/\n")
```

**Run:**
```bash
cd ~/tdp43-dysfunction-score
Rscript scripts/04_visualization/create_plots.R
```

**Plots created:**
- ☐ volcano_plot.png
- ☐ ma_plot.png
- ☐ pca_plot.png
- ☐ heatmap_top50.png

**Status:** ☐ Complete  
**Date:**  

---

### 4.2 Commit Phase 4
```bash
cd ~/tdp43-dysfunction-score

git add scripts/04_visualization/
git add results/figures/
git add docs/genome_wide_workflow.md
git commit -m "Phase 4 complete: created publication-quality visualizations"
git push origin main
```

**Status:** ☐ Complete

---

## Progress Tracker

| Phase | Status | Date | Notes |
|-------|--------|------|-------|
| 1. Setup & Download | ☑ | Feb 14, 2026 | 67GB data, 646K transcripts, 79K genes |
| 2. Quantification | ☐ | | |
| 3. DESeq2 Analysis | ☐ | | |
| 4. Visualization | ☐ | | |
| 5. ML Preparation | ☐ | | |

---

## Final Results Summary

**Total genes analyzed:**  
**Significant DEGs (padj < 0.05, |LFC| >= 1):**  
**Upregulated in KO:**  
**Downregulated in KO:**  

**Key findings:**

**Next steps:**
