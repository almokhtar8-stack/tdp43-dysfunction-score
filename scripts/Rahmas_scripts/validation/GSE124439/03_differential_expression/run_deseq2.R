#!/usr/bin/env Rscript
# DESeq2 Differential Expression Analysis - GSE124439
# Path: /mnt/h/KAUST/tdp43-dysfunction-score/scripts/Rahmas_scripts/validation/GSE124439/03_differential_expression/run_deseq2.R
# Date" April 16,2026
# Capture overall start time
start_time <- Sys.time()

cat("==================================================\n")
cat("DESeq2 Differential Expression Analysis - GSE124439\n")
cat("Start Time:", format(start_time, "%Y-%m-%d %H:%M:%S"), "\n")
cat("Comparison: ALS vs Control\n")
cat("==================================================\n\n")

# Load libraries
suppressPackageStartupMessages({
  library(DESeq2)
  library(tximport)
  library(readr)
  library(dplyr)
  library(tibble)
})

# 1. Define Absolute Paths
PROJECT_DIR <- "/mnt/h/KAUST/tdp43-dysfunction-score"
BASE_DIR <- file.path(PROJECT_DIR, "scripts/Rahmas_scripts/validation/GSE124439")
PROCESSED_DIR <- file.path(BASE_DIR, "results/processed")
TABLES_DIR <- file.path(BASE_DIR, "results/tables")
MODELS_DIR <- file.path(BASE_DIR, "results/models")

# Create directories
dir.create(TABLES_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(MODELS_DIR, recursive = TRUE, showWarnings = FALSE)

cat("Step 1: Loading summarized counts (txi)...\n")
txi_path <- file.path(PROCESSED_DIR, "GSE124439_txi.rds")
if (!file.exists(txi_path)) { stop("ERROR: GSE124439_txi.rds not found!") }
txi <- readRDS(txi_path)
cat("  - Loaded counts for", nrow(txi$counts), "genes\n\n")

cat("Step 2: Creating sample metadata for 18 samples...\n")
samples <- data.frame(
  sample_id = colnames(txi$counts),
  condition = factor(c(rep("ALS", 9), rep("Control", 9)), levels = c("Control", "ALS")),
  stringsAsFactors = FALSE
)
print(samples)
cat("\n")

cat("Step 3: Creating DESeq2 dataset...\n")
dds <- DESeqDataSetFromTximport(txi, colData = samples, design = ~ condition)

cat("Step 4: Pre-filtering (at least 10 reads total)...\n")
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
cat("  - Retained", sum(keep), "genes (removed", sum(!keep), "low-count genes)\n\n")

cat("Step 5: Running DESeq2 (this may take a few minutes)...\n")
deseq_start <- Sys.time()
dds <- DESeq(dds)
deseq_end <- Sys.time()
cat("  ✓ DESeq2 complete in:", round(difftime(deseq_end, deseq_start, units="mins"), 2), "minutes\n\n")

cat("Step 6: Extracting results (ALS vs Control)...\n")
res <- results(dds, contrast = c("condition", "ALS", "Control"))
summary(res)

# Order by significance and convert to dataframe
res_df <- as.data.frame(res) %>%
  rownames_to_column("gene_id") %>%
  arrange(padj)

cat("\nStep 7: Filtering significant genes (padj < 0.05, |log2FC| > 1)...\n")
sig_genes <- res_df %>% filter(padj < 0.05 & abs(log2FoldChange) > 1)
up_in_als <- sig_genes %>% filter(log2FoldChange > 1)
down_in_als <- sig_genes %>% filter(log2FoldChange < -1)

cat("  - Total significant genes:", nrow(sig_genes), "\n")
cat("  - Upregulated in ALS:", nrow(up_in_als), "\n")
cat("  - Downregulated in ALS:", nrow(down_in_als), "\n\n")

cat("Step 8: Saving results to /results/tables/ and /results/models/...\n")
write.csv(res_df, file.path(TABLES_DIR, "deseq2_results_all.csv"), row.names = FALSE)
write.csv(sig_genes, file.path(TABLES_DIR, "deseq2_results_significant.csv"), row.names = FALSE)
saveRDS(dds, file.path(MODELS_DIR, "GSE124439_dds.rds"))

# Final Timing
end_time <- Sys.time()
total_duration <- difftime(end_time, start_time, units="mins")

cat("\n==================================================\n")
cat("✓ DESeq2 Analysis Complete!\n")
cat("Overall Start: ", format(start_time, "%H:%M:%S"), "\n")
cat("Overall End:   ", format(end_time, "%H:%M:%S"), "\n")
cat("Total Runtime: ", round(total_duration, 2), "minutes\n")
cat("==================================================\n")
