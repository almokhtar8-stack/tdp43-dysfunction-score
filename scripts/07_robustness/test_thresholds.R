#!/usr/bin/env Rscript
# Robustness Analysis - Test Different DE Thresholds
# Author: Ahmed Bukhamsin

library(DESeq2)
library(clusterProfiler)
library(org.Hs.eg.db)

# Load DESeq2 results
res <- read.csv("results/tables/deseq2_results_all.csv")

# Define 3 threshold combinations
thresholds <- list(
  baseline = list(padj = 0.05, log2fc = 1),
  strict_p = list(padj = 0.01, log2fc = 1),
  strict_fc = list(padj = 0.05, log2fc = 1.5)
)

# Store results
results_table <- data.frame()

# Loop through each threshold
for (name in names(thresholds)) {
  t <- thresholds[[name]]
  
  # Filter significant genes
  sig <- res[!is.na(res$padj) & 
             res$padj < t$padj & 
             abs(res$log2FoldChange) > t$log2fc, ]
  
  cat("\n", name, ": ", nrow(sig), " genes\n")
  
  # Convert to Entrez IDs
  ensembl_clean <- gsub("\\..*", "", sig$gene_id)
  entrez <- mapIds(org.Hs.eg.db, ensembl_clean, "ENTREZID", "ENSEMBL")
  entrez <- entrez[!is.na(entrez)]
  
  # Run GO enrichment
  go_result <- enrichGO(
    gene = entrez,
    OrgDb = org.Hs.eg.db,
    ont = "BP",
    pvalueCutoff = 0.05
  )
  
  # Get top pathway
  if (nrow(go_result@result) > 0) {
    top_pathway <- go_result@result$Description[1]
    ecm_row <- grep("extracellular matrix", go_result@result$Description, 
                    ignore.case = TRUE)[1]
    ecm_rank <- ifelse(is.na(ecm_row), NA, ecm_row)
    ecm_pval <- ifelse(is.na(ecm_row), NA, 
                       go_result@result$p.adjust[ecm_row])
  } else {
    top_pathway <- "None"
    ecm_rank <- NA
    ecm_pval <- NA
  }
  
  # Store result
  results_table <- rbind(results_table, data.frame(
    threshold = name,
    padj_cutoff = t$padj,
    log2fc_cutoff = t$log2fc,
    n_genes = nrow(sig),
    top_pathway = top_pathway,
    ecm_rank = ecm_rank,
    ecm_pval = ecm_pval
  ))
}

# Save results
write.csv(results_table, 
          "results/tables/robustness_analysis.csv", 
          row.names = FALSE)

print(results_table)

cat("\n✅ Robustness analysis complete!\n")
