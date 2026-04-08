#!/usr/bin/env Rscript

# Load necessary libraries
suppressPackageStartupMessages({
  library(biomaRt)
  library(tidyverse)
})

# 1. Load feature importance
input_path <- "results/models/feature_importance.csv"
if (!file.exists(input_path)) {
  stop(paste("Error: Input file not found at", input_path))
}

feat <- read.csv(input_path)

# 2. Connect to Ensembl with error handling
cat("Connecting to Ensembl... (this may take a moment)\n")
tryCatch({
  mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  
  # 3. Get gene symbols
  annot <- getBM(
    attributes = c("ensembl_gene_id", "hgnc_symbol", "description"),
    filters    = "ensembl_gene_id",
    values     = feat$gene,
    mart       = mart
  )

  # 4. Merge and sort
  feat_annotated <- feat %>%
    left_join(annot, by = c("gene" = "ensembl_gene_id")) %>%
    arrange(desc(importance))

  # Ensure the output directory exists
  if (!dir.exists("results/models")) {
    dir.create("results/models", recursive = TRUE)
  }

  # 5. Save results
  write.csv(feat_annotated,
            "results/models/r_feature_importance_annotated.csv",
            row.names = FALSE)

  cat("Success! Results saved to results/models/r_feature_importance_annotated.csv\n")
  
  # 6. Display Top 20
  cat("\nTop 20 genes with symbols:\n")
  print(head(feat_annotated[, c("hgnc_symbol", "importance", "description")], 20))

}, error = function(e) {
  cat("An error occurred during the biomaRt query:\n")
  print(e)
})

