#!/usr/bin/env Rscript
cat("Creating tx2gene mapping...\n")

library(GenomicFeatures)

txdb <- makeTxDbFromGFF("data/references/Homo_sapiens.GRCh38.116.gtf.gz")
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- select(txdb, keys = k, columns = "GENEID", keytype = "TXNAME")

tx2gene$GENEID <- gsub("\\..*", "", tx2gene$GENEID)
tx2gene$TXNAME <- gsub("\\..*", "", tx2gene$TXNAME)
tx2gene <- unique(tx2gene)

saveRDS(tx2gene, "data/references/tx2gene.rds")
write.csv(tx2gene, "data/references/tx2gene.csv", row.names = FALSE)

cat("✓ Created:", nrow(tx2gene), "transcripts →", length(unique(tx2gene$GENEID)), "genes\n")
