#!/usr/bin/env Rscript
# Create transcript-to-gene mapping
# Working directory: ~/tdp43-dysfunction-score

library(GenomicFeatures)

cat("Creating tx2gene mapping...\n")

# Create TxDb from GTF
txdb <- makeTxDbFromGFF("genomics/references/Homo_sapiens.GRCh38.116.gtf.gz")

# Extract mapping
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, keys = k, columns = "GENEID", keytype = "TXNAME")

# Remove version numbers
tx2gene$GENEID <- gsub("\\..*", "", tx2gene$GENEID)
tx2gene$TXNAME <- gsub("\\..*", "", tx2gene$TXNAME)
tx2gene <- unique(tx2gene)

# Save
saveRDS(tx2gene, "genomics/references/tx2gene.rds")
write.csv(tx2gene, "genomics/references/tx2gene.csv", row.names = FALSE)

cat("✓ Created tx2gene with", nrow(tx2gene), "transcripts\n")
cat("✓ Unique genes:", length(unique(tx2gene$GENEID)), "\n")

