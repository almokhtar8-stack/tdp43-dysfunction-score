library(biomaRt)
library(tidyverse)

# Define Project Paths
BASE_DIR <- "/mnt/h/KAUST/tdp43-dysfunction-score/scripts/Rahmas_scripts/validation/GSE124439"
FEAT_PATH <- file.path(BASE_DIR, "results/models/feature_importance.csv")

# Load feature importance
if(!file.exists(FEAT_PATH)) stop("Run ML modeling first to generate feature importance!")
feat <- read.csv(FEAT_PATH)

# Connect to Ensembl
mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

# Get gene symbols
annot <- getBM(
  attributes = c("ensembl_gene_id", "hgnc_symbol", "description"),
  filters    = "ensembl_gene_id",
  values     = gsub("\\..*", "", feat$gene), # Clean version numbers
  mart       = mart
)

# Merge
feat_annotated <- feat %>%
  mutate(clean_id = gsub("\\..*", "", gene)) %>%
  left_join(annot, by = c("clean_id" = "ensembl_gene_id")) %>%
  arrange(desc(importance))

write.csv(feat_annotated,
          file.path(BASE_DIR, "results/models/feature_importance_annotated.csv"),
          row.names = FALSE)

cat("Top 20 genes with symbols:\n")
print(head(feat_annotated[, c("hgnc_symbol", "importance", "description")], 20))
