#!/usr/bin/env Rscript
# DESeq2 Differential Expression Analysis
# Date: Feb 14, 2026
# Comparison: KO vs Rescue (TDP-43 dysfunction)

cat("==================================================\n")
cat("DESeq2 Differential Expression Analysis\n")
cat("Comparison: TDP-43 KO vs Rescue\n")
cat("==================================================\n\n")

# Load libraries
suppressPackageStartupMessages({
  library(DESeq2)
  library(tximport)
  library(readr)
  library(dplyr)
  library(tibble)
})

cat("Step 1: Load tx2gene mapping...\n")
# Load tx2gene mapping (created in Phase 1)
tx2gene <- read.csv("data/references/tx2gene.csv")
cat("  - Loaded", nrow(tx2gene), "transcript-to-gene mappings\n\n")

cat("Step 2: Create sample metadata...\n")
# Sample metadata
samples <- data.frame(
  sample_id = c("SRR10045016", "SRR10045017", "SRR10045018",
                "SRR10045019", "SRR10045020", "SRR10045021"),
  condition = factor(c("KO", "KO", "KO", "Rescue", "Rescue", "Rescue"),
                     levels = c("Rescue", "KO")),  # Rescue as reference
  replicate = c(1, 2, 3, 1, 2, 3),
  stringsAsFactors = FALSE
)

print(samples)
cat("\n")

cat("Step 3: Locate Salmon quantification files...\n")
# Build file paths
files <- file.path("results/salmon", samples$sample_id, "quant.sf")
names(files) <- samples$sample_id

# Verify files exist
if (!all(file.exists(files))) {
  stop("ERROR: Not all Salmon quant.sf files found!")
}
cat("  - All 6 quant.sf files found ✓\n\n")

cat("Step 4: Import counts with tximport...\n")
cat("  (This may take 2-3 minutes...)\n")
# Import transcript-level counts and summarize to gene-level
txi <- tximport(files, 
                type = "salmon",
                tx2gene = tx2gene,
                ignoreTxVersion = TRUE)

cat("  - Imported counts for", nrow(txi$counts), "genes\n")
cat("  - Across", ncol(txi$counts), "samples\n\n")

cat("Step 5: Create DESeq2 dataset...\n")
# Create DESeqDataSet
dds <- DESeqDataSetFromTximport(txi,
                                colData = samples,
                                design = ~ condition)

cat("  - DESeq2 dataset created\n")
cat("  - Genes:", nrow(dds), "\n")
cat("  - Samples:", ncol(dds), "\n\n")

cat("Step 6: Pre-filtering (remove low-count genes)...\n")
# Keep genes with at least 10 reads total across all samples
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
cat("  - Retained", sum(keep), "genes (removed", sum(!keep), "low-count genes)\n\n")

cat("Step 7: Run DESeq2 differential expression...\n")
cat("  (This may take 5-10 minutes...)\n")
# Run DESeq2
dds <- DESeq(dds)
cat("  ✓ DESeq2 analysis complete!\n\n")

cat("Step 8: Extract results (KO vs Rescue)...\n")
# Get results
# Positive log2FC = higher in KO
# Negative log2FC = higher in Rescue
res <- results(dds, contrast = c("condition", "KO", "Rescue"))

# Summary
cat("\n")
summary(res)
cat("\n")

cat("Step 9: Order by adjusted p-value...\n")
# Order by significance
res_ordered <- res[order(res$padj), ]

# Convert to data frame with gene symbols
res_df <- as.data.frame(res_ordered) %>%
  rownames_to_column("gene_id") %>%
  arrange(padj)

cat("  - Results ordered by adjusted p-value\n\n")

cat("Step 10: Filter significant genes...\n")
# Filter significant genes (padj < 0.05, |log2FC| > 1)
sig_genes <- res_df %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

cat("  - Total significant genes (padj < 0.05, |log2FC| > 1):", nrow(sig_genes), "\n")

# Upregulated in KO (higher in KO vs Rescue)
up_in_ko <- sig_genes %>% filter(log2FoldChange > 1)
cat("  - Upregulated in KO:", nrow(up_in_ko), "\n")

# Downregulated in KO (higher in Rescue)
down_in_ko <- sig_genes %>% filter(log2FoldChange < -1)
cat("  - Downregulated in KO:", nrow(down_in_ko), "\n\n")

cat("Step 11: Save results...\n")
# Create output directory
dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)

# Save all results
write.csv(res_df, 
          "results/tables/deseq2_results_all.csv",
          row.names = FALSE)
cat("  - Saved: results/tables/deseq2_results_all.csv\n")

# Save significant genes only
write.csv(sig_genes,
          "results/tables/deseq2_results_significant.csv",
          row.names = FALSE)
cat("  - Saved: results/tables/deseq2_results_significant.csv\n")

# Save upregulated in KO
write.csv(up_in_ko,
          "results/tables/genes_upregulated_in_KO.csv",
          row.names = FALSE)
cat("  - Saved: results/tables/genes_upregulated_in_KO.csv\n")

# Save downregulated in KO
write.csv(down_in_ko,
          "results/tables/genes_downregulated_in_KO.csv",
          row.names = FALSE)
cat("  - Saved: results/tables/genes_downregulated_in_KO.csv\n\n")

cat("Step 12: Save DESeq2 object...\n")
# Save DESeq2 object for later use
saveRDS(dds, "results/models/dds.rds")
cat("  - Saved: results/models/dds.rds\n\n")

cat("Step 13: Generate summary statistics...\n")
# Summary statistics
summary_stats <- data.frame(
  metric = c(
    "Total genes analyzed",
    "Significant genes (padj < 0.05, |log2FC| > 1)",
    "Upregulated in KO",
    "Downregulated in KO",
    "Percent significant"
  ),
  value = c(
    nrow(res_df),
    nrow(sig_genes),
    nrow(up_in_ko),
    nrow(down_in_ko),
    paste0(round(100 * nrow(sig_genes) / nrow(res_df), 2), "%")
  )
)

print(summary_stats)

write.csv(summary_stats,
          "results/tables/deseq2_summary_stats.csv",
          row.names = FALSE)
cat("\n  - Saved: results/tables/deseq2_summary_stats.csv\n")

cat("\n==================================================\n")
cat("✓ DESeq2 Analysis Complete!\n")
cat("==================================================\n")
cat("\nTop 10 most significant genes:\n")
print(head(res_df, 10))
cat("\n")
