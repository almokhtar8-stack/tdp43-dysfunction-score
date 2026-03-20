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
txi <- tximport(files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE)

# Save
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
saveRDS(txi, "data/processed/genome_wide_txi.rds")

cat("\n✓ Import complete!\n")
cat("  Genes:", nrow(txi$counts), "\n")
cat("  Samples:", ncol(txi$counts), "\n")
cat("  Saved to: data/processed/genome_wide_txi.rds\n")

