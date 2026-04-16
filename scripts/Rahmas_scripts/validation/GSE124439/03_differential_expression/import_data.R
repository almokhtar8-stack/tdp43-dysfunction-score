#!/usr/bin/env Rscript
# Import Salmon quantifications with tximport
# Path: scripts/Rahmas_scripts/validation/GSE124439/03_differential_expression/import_data.R

library(tximport)

cat("==================================================\n")
cat("Importing Salmon Quantifications for GSE124439\n")
cat("==================================================\n\n")

# 1. Define Paths
PROJECT_DIR <- "/mnt/h/KAUST/tdp43-dysfunction-score"
BASE_DIR <- file.path(PROJECT_DIR, "scripts/Rahmas_scripts/validation/GSE124439")
SALMON_DIR <- file.path(BASE_DIR, "results/salmon")
PROCESSED_DIR <- file.path(BASE_DIR, "results/processed")

# 2. Load tx2gene (Maps transcript IDs to Gene IDs)
# Ensure this file exists in your references
tx2gene_path <- file.path(PROJECT_DIR, "data/references/tx2gene.rds")
if (!file.exists(tx2gene_path)) {
  stop("tx2gene.rds not found at: ", tx2gene_path)
}
tx2gene <- readRDS(tx2gene_path)

# 3. Find quant.sf files for the 18 samples
files <- list.files(SALMON_DIR, 
                    pattern = "quant.sf", 
                    recursive = TRUE, 
                    full.names = TRUE)

# Filter for just the GSE124439 samples (9 ALS + 9 Control)
files <- files[grep("ALS-|Control-", files)]
names(files) <- basename(dirname(files))

cat("Found", length(files), "quantification files\n")

# 4. Import using tximport
# ignoreTxVersion is TRUE because your Salmon index uses versioned IDs (e.g., .1, .6)
txi <- tximport(files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE)

# 5. Save Processed Data
dir.create(PROCESSED_DIR, showWarnings = FALSE, recursive = TRUE)
saveRDS(txi, file.path(PROCESSED_DIR, "GSE124439_txi.rds"))

cat("\n✓ Import complete!\n")
cat("  Genes:", nrow(txi$counts), "\n")
cat("  Samples:", ncol(txi$counts), "\n")
cat("  Saved to:", file.path(PROCESSED_DIR, "GSE124439_txi.rds"), "\n")
