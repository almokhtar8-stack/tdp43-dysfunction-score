#!/usr/bin/env Rscript
# Pathway Enrichment Analysis
# Date: Feb 14, 2026
# Purpose: GO/KEGG enrichment of TDP-43 DE genes

cat("==================================================\n")
cat("Pathway Enrichment Analysis\n")
cat("TDP-43 KO vs Rescue - Upregulated Genes\n")
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

# Create output directory
dir.create("results/enrichment", recursive = TRUE, showWarnings = FALSE)

cat("Step 1: Load differential expression results...\n")

# Load upregulated genes
up_genes <- read.csv("results/tables/genes_upregulated_in_KO.csv")
down_genes <- read.csv("results/tables/genes_downregulated_in_KO.csv")
all_results <- read.csv("results/tables/deseq2_results_all.csv")

cat("  - Upregulated genes:", nrow(up_genes), "\n")
cat("  - Downregulated genes:", nrow(down_genes), "\n")
cat("  - Total genes:", nrow(all_results), "\n\n")

cat("Step 2: Convert Ensembl IDs to Entrez IDs...\n")

# Function to convert IDs
convert_ids <- function(ensembl_ids) {
  # Remove version numbers (e.g., ENSG00000000003.15 -> ENSG00000000003)
  ensembl_clean <- gsub("\\..*", "", ensembl_ids)
  
  # Convert to Entrez
  entrez <- mapIds(org.Hs.eg.db,
                   keys = ensembl_clean,
                   column = "ENTREZID",
                   keytype = "ENSEMBL",
                   multiVals = "first")
  
  # Remove NAs
  entrez <- entrez[!is.na(entrez)]
  
  return(entrez)
}

# Convert upregulated genes
up_entrez <- convert_ids(up_genes$gene_id)
cat("  - Upregulated: converted", length(up_entrez), "of", nrow(up_genes), "genes\n")

# Convert downregulated genes
down_entrez <- convert_ids(down_genes$gene_id)
cat("  - Downregulated: converted", length(down_entrez), "of", nrow(down_genes), "genes\n\n")

# ============================================
# GO ENRICHMENT - UPREGULATED GENES
# ============================================

cat("Step 3: GO Enrichment (Upregulated genes)...\n")

# Biological Process
go_bp_up <- enrichGO(gene = up_entrez,
                     OrgDb = org.Hs.eg.db,
                     ont = "BP",
                     pAdjustMethod = "BH",
                     pvalueCutoff = 0.05,
                     qvalueCutoff = 0.2,
                     readable = TRUE)

cat("  - Biological Process: enriched terms:", nrow(go_bp_up@result[go_bp_up@result$p.adjust < 0.05,]), "\n")

# Molecular Function
go_mf_up <- enrichGO(gene = up_entrez,
                     OrgDb = org.Hs.eg.db,
                     ont = "MF",
                     pAdjustMethod = "BH",
                     pvalueCutoff = 0.05,
                     qvalueCutoff = 0.2,
                     readable = TRUE)

cat("  - Molecular Function: enriched terms:", nrow(go_mf_up@result[go_mf_up@result$p.adjust < 0.05,]), "\n")

# Cellular Component
go_cc_up <- enrichGO(gene = up_entrez,
                     OrgDb = org.Hs.eg.db,
                     ont = "CC",
                     pAdjustMethod = "BH",
                     pvalueCutoff = 0.05,
                     qvalueCutoff = 0.2,
                     readable = TRUE)

cat("  - Cellular Component: enriched terms:", nrow(go_cc_up@result[go_cc_up@result$p.adjust < 0.05,]), "\n\n")

# ============================================
# KEGG PATHWAY ENRICHMENT
# ============================================

cat("Step 4: KEGG Pathway Enrichment (Upregulated)...\n")

kegg_up <- enrichKEGG(gene = up_entrez,
                      organism = 'hsa',
                      pvalueCutoff = 0.05,
                      qvalueCutoff = 0.2)

# Convert to readable gene names
if (nrow(kegg_up@result) > 0) {
  kegg_up <- setReadable(kegg_up, OrgDb = org.Hs.eg.db, keyType = "ENTREZID")
  cat("  - Enriched KEGG pathways:", nrow(kegg_up@result[kegg_up@result$p.adjust < 0.05,]), "\n\n")
} else {
  cat("  - No significantly enriched KEGG pathways\n\n")
}

# ============================================
# VISUALIZATIONS
# ============================================

cat("Step 5: Creating visualizations...\n")

# Plot 1: GO BP Bar Plot (Top 20)
if (nrow(go_bp_up@result[go_bp_up@result$p.adjust < 0.05,]) > 0) {
  p1 <- barplot(go_bp_up, 
                showCategory = 20,
                title = "GO Biological Process - Upregulated in TDP-43 KO") +
    theme(axis.text.y = element_text(size = 8))
  
  ggsave("results/enrichment/go_bp_upregulated_barplot.png", 
         p1, width = 12, height = 10, dpi = 300)
  cat("  ✓ GO BP bar plot saved\n")
}

# Plot 2: GO BP Dot Plot (Top 20)
if (nrow(go_bp_up@result[go_bp_up@result$p.adjust < 0.05,]) > 0) {
  p2 <- dotplot(go_bp_up, 
                showCategory = 20,
                title = "GO Biological Process - Upregulated in TDP-43 KO") +
    theme(axis.text.y = element_text(size = 8))
  
  ggsave("results/enrichment/go_bp_upregulated_dotplot.png", 
         p2, width = 12, height = 10, dpi = 300)
  cat("  ✓ GO BP dot plot saved\n")
}

# Plot 3: KEGG Pathway Bar Plot
if (nrow(kegg_up@result[kegg_up@result$p.adjust < 0.05,]) > 0) {
  p3 <- barplot(kegg_up, 
                showCategory = 15,
                title = "KEGG Pathways - Upregulated in TDP-43 KO")
  
  ggsave("results/enrichment/kegg_upregulated_barplot.png", 
         p3, width = 12, height = 8, dpi = 300)
  cat("  ✓ KEGG bar plot saved\n")
}

# Plot 4: GO MF Bar Plot
if (nrow(go_mf_up@result[go_mf_up@result$p.adjust < 0.05,]) > 0) {
  p4 <- barplot(go_mf_up, 
                showCategory = 15,
                title = "GO Molecular Function - Upregulated in TDP-43 KO")
  
  ggsave("results/enrichment/go_mf_upregulated_barplot.png", 
         p4, width = 12, height = 8, dpi = 300)
  cat("  ✓ GO MF bar plot saved\n")
}

# ============================================
# DOWNREGULATED GENES (BRIEF ANALYSIS)
# ============================================

cat("\nStep 6: GO Enrichment (Downregulated genes)...\n")

# GO BP for downregulated
go_bp_down <- enrichGO(gene = down_entrez,
                       OrgDb = org.Hs.eg.db,
                       ont = "BP",
                       pAdjustMethod = "BH",
                       pvalueCutoff = 0.05,
                       qvalueCutoff = 0.2,
                       readable = TRUE)

cat("  - Biological Process: enriched terms:", nrow(go_bp_down@result[go_bp_down@result$p.adjust < 0.05,]), "\n")

if (nrow(go_bp_down@result[go_bp_down@result$p.adjust < 0.05,]) > 0) {
  p5 <- barplot(go_bp_down, 
                showCategory = 15,
                title = "GO Biological Process - Downregulated in TDP-43 KO")
  
  ggsave("results/enrichment/go_bp_downregulated_barplot.png", 
         p5, width = 12, height = 8, dpi = 300)
  cat("  ✓ GO BP (downregulated) bar plot saved\n")
}

# ============================================
# SAVE RESULTS TO CSV
# ============================================

cat("\nStep 7: Saving results to CSV...\n")

# Save GO BP upregulated
if (nrow(go_bp_up@result) > 0) {
  write.csv(go_bp_up@result, 
            "results/enrichment/go_bp_upregulated.csv", 
            row.names = FALSE)
  cat("  ✓ GO BP (upregulated) CSV saved\n")
}

# Save GO MF upregulated
if (nrow(go_mf_up@result) > 0) {
  write.csv(go_mf_up@result, 
            "results/enrichment/go_mf_upregulated.csv", 
            row.names = FALSE)
  cat("  ✓ GO MF (upregulated) CSV saved\n")
}

# Save KEGG upregulated
if (nrow(kegg_up@result) > 0) {
  write.csv(kegg_up@result, 
            "results/enrichment/kegg_upregulated.csv", 
            row.names = FALSE)
  cat("  ✓ KEGG (upregulated) CSV saved\n")
}

# Save GO BP downregulated
if (nrow(go_bp_down@result) > 0) {
  write.csv(go_bp_down@result, 
            "results/enrichment/go_bp_downregulated.csv", 
            row.names = FALSE)
  cat("  ✓ GO BP (downregulated) CSV saved\n")
}

# ============================================
# SUMMARY
# ============================================

cat("\n==================================================\n")
cat("✓ Enrichment Analysis Complete!\n")
cat("==================================================\n\n")

cat("Results Summary:\n")
cat("  GO Biological Process (up):", 
    nrow(go_bp_up@result[go_bp_up@result$p.adjust < 0.05,]), "terms\n")
cat("  GO Molecular Function (up):", 
    nrow(go_mf_up@result[go_mf_up@result$p.adjust < 0.05,]), "terms\n")
cat("  GO Cellular Component (up):", 
    nrow(go_cc_up@result[go_cc_up@result$p.adjust < 0.05,]), "terms\n")
cat("  KEGG Pathways (up):", 
    nrow(kegg_up@result[kegg_up@result$p.adjust < 0.05,]), "pathways\n")
cat("  GO Biological Process (down):", 
    nrow(go_bp_down@result[go_bp_down@result$p.adjust < 0.05,]), "terms\n\n")

cat("Top 5 Enriched GO Terms (Upregulated):\n")
if (nrow(go_bp_up@result) > 0) {
  top5 <- head(go_bp_up@result[order(go_bp_up@result$p.adjust), 
                                c("Description", "p.adjust", "Count")], 5)
  print(top5)
}

cat("\nOutput files saved to: results/enrichment/\n")
