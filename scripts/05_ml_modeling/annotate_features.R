library(biomaRt)
library(tidyverse)

# Load feature importance
feat <- read.csv("results/models/feature_importance.csv")

# Connect to Ensembl
mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

# Get gene symbols
annot <- getBM(
  attributes = c("ensembl_gene_id", "hgnc_symbol", "description"),
  filters    = "ensembl_gene_id",
  values     = feat$gene,
  mart       = mart
)

# Merge
feat_annotated <- feat %>%
  left_join(annot, by = c("gene" = "ensembl_gene_id")) %>%
  arrange(desc(importance))

write.csv(feat_annotated,
          "results/models/feature_importance_annotated.csv",
          row.names = FALSE)

cat("Top 20 genes with symbols:\n")
print(head(feat_annotated[, c("hgnc_symbol", "importance", "description")], 20))
