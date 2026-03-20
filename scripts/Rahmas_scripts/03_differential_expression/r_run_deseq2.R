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
