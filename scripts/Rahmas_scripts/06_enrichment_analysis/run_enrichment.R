#!/usr/bin/env Rscript
# Pathway Enrichment Analysis - GSE124439
# Date: April 16, 2026
# Purpose: GO/KEGG enrichment with process tracking

# Capture overall start time
overall_start <- Sys.time()

cat("==================================================\n")
cat("Pathway Enrichment Analysis - GSE124439\n")
cat("Start Time:", format(overall_start, "%Y-%m-%d %H:%M:%S"), "\n")
cat("Comparison: ALS vs Control\n")
cat("==================================================\n\n")

# Load libraries
suppressPackageStartupMessages({
  library(clusterProfiler)
  library(org.Hs.eg.db)
  library(enrichplot)
  library(DOSE)
  library(ggplot2)
  library(dplyr)
  library(tidyr)
})

# Define Paths
PROJECT_DIR <- "/mnt/h/KAUST/tdp43-dysfunction-score"
BASE_DIR <- file.path(PROJECT_DIR, "scripts/Rahmas_scripts/validation/GSE124439")
TABLES_DIR <- file.path(BASE_DIR, "results/tables")
ENRICH_OUT_DIR <- file.path(BASE_DIR, "results/enrichment")

dir.create(ENRICH_OUT_DIR, recursive = TRUE, showWarnings = FALSE)

cat("Step 1 [", format(Sys.time(), "%H:%M:%S"), "]: Loading DE results...\n")
up_genes <- read.csv(file.path(TABLES_DIR, "deseq2_results_significant.csv")) %>% filter(log2FoldChange > 1)
down_genes <- read.csv(file.path(TABLES_DIR, "deseq2_results_significant.csv")) %>% filter(log2FoldChange < -1)

cat("  - Upregulated in ALS:", nrow(up_genes), "\n")
cat("  - Downregulated in ALS:", nrow(down_genes), "\n\n")

cat("Step 2 [", format(Sys.time(), "%H:%M:%S"), "]: Converting Ensembl to Entrez IDs...\n")
convert_ids <- function(ensembl_ids) {
  ensembl_clean <- gsub("\\..*", "", ensembl_ids)
  entrez <- mapIds(org.Hs.eg.db, keys = ensembl_clean, column = "ENTREZID",
                   keytype = "ENSEMBL", multiVals = "first")
  return(entrez[!is.na(entrez)])
}

up_entrez <- convert_ids(up_genes$gene_id)
down_entrez <- convert_ids(down_genes$gene_id)

# ============================================
# GO ENRICHMENT
# ============================================
cat("Step 3 [", format(Sys.time(), "%H:%M:%S"), "]: Running GO BP Enrichment (Upregulated)...\n")
go_start <- Sys.time()
go_bp_up <- enrichGO(gene = up_entrez, OrgDb = org.Hs.eg.db, ont = "BP", pAdjustMethod = "BH", readable = TRUE)
cat("  - GO BP completed in:", round(difftime(Sys.time(), go_start, units="secs"), 2), "seconds\n\n")

# ============================================
# KEGG PATHWAY ENRICHMENT
# ============================================
cat("Step 4 [", format(Sys.time(), "%H:%M:%S"), "]: Running KEGG Pathway Enrichment (Upregulated)...\n")
kegg_start <- Sys.time()
kegg_up <- try(enrichKEGG(gene = up_entrez, organism = 'hsa'), silent = TRUE)
cat("  - KEGG completed in:", round(difftime(Sys.time(), kegg_start, units="secs"), 2), "seconds\n\n")

# ============================================
# VISUALIZATIONS
# ============================================
cat("Step 5 [", format(Sys.time(), "%H:%M:%S"), "]: Creating visualizations...\n")
if (!is.null(go_bp_up) && nrow(go_bp_up@result[go_bp_up@result$p.adjust < 0.05,]) > 0) {
  p1 <- dotplot(go_bp_up, showCategory = 20, title = "GO BP - Upregulated in ALS")
  ggsave(file.path(ENRICH_OUT_DIR, "go_bp_upregulated_dotplot.png"), p1, width = 12, height = 10)
}

# ============================================
# DOWNREGULATED GENES
# ============================================
cat("Step 6 [", format(Sys.time(), "%H:%M:%S"), "]: Running GO BP Enrichment (Downregulated)...\n")
go_bp_down <- enrichGO(gene = down_entrez, OrgDb = org.Hs.eg.db, ont = "BP", pAdjustMethod = "BH", readable = TRUE)

if (!is.null(go_bp_down) && nrow(go_bp_down@result[go_bp_down@result$p.adjust < 0.05,]) > 0) {
  p2 <- barplot(go_bp_down, showCategory = 15, title = "GO BP - Downregulated in ALS")
  ggsave(file.path(ENRICH_OUT_DIR, "go_bp_downregulated_barplot.png"), p2, width = 12, height = 8)
}

# ============================================
# SAVE RESULTS
# ============================================
cat("Step 7 [", format(Sys.time(), "%H:%M:%S"), "]: Saving final CSV results...\n")
write.csv(as.data.frame(go_bp_up), file.path(ENRICH_OUT_DIR, "go_bp_upregulated.csv"), row.names = FALSE)
write.csv(as.data.frame(go_bp_down), file.path(ENRICH_OUT_DIR, "go_bp_downregulated.csv"), row.names = FALSE)

# Final Timing
overall_end <- Sys.time()
total_duration <- difftime(overall_end, overall_start, units="mins")

cat("\n==================================================\n")
cat("✓ Enrichment Analysis Complete!\n")
cat("Overall Start: ", format(overall_start, "%H:%M:%S"), "\n")
cat("Overall End:   ", format(overall_end, "%H:%M:%S"), "\n")
cat("Total Runtime: ", round(total_duration, 2), "minutes\n")
cat("==================================================\n")
