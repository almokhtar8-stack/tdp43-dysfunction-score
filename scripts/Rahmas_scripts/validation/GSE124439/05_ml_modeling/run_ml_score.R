# ============================================================
# Phase 5: TDP-43 Dysfunction Score - ML Modeling (GSE124439)
# ============================================================

# Load libraries
library(tidyverse)
library(caret)
library(randomForest)
library(e1071)
library(glmnet)
library(ggplot2)
library(pheatmap)
library(RColorBrewer)
library(scales)
library(gridExtra)
library(viridis)
library(DESeq2)

# Define Paths
PROJECT_DIR <- "/mnt/h/KAUST/tdp43-dysfunction-score"
BASE_DIR <- file.path(PROJECT_DIR, "scripts/Rahmas_scripts/validation/GSE124439")
TABLES_DIR <- file.path(BASE_DIR, "results/tables")
MODELS_DIR <- file.path(BASE_DIR, "results/models")
FIGURES_DIR <- file.path(BASE_DIR, "results/figures/ml")

dir.create(MODELS_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(FIGURES_DIR, showWarnings = FALSE, recursive = TRUE)

cat("\n📂 Loading data from GSE124439 validation set...\n")
dds <- readRDS(file.path(MODELS_DIR, "dds.rds"))
sig_genes <- read.csv(file.path(TABLES_DIR, "deseq2_results_significant.csv"), row.names = 1)
go_bp <- read.csv(file.path(BASE_DIR, "results/enrichment/go_bp_upregulated.csv"))

# Extract VST counts
vst_counts <- assay(vst(dds, blind = FALSE))
sig_gene_ids <- intersect(rownames(sig_genes), rownames(vst_counts))
vst_sig <- vst_counts[sig_gene_ids, ]

# Build Feature Matrix
feature_matrix <- as.data.frame(t(vst_sig))
feature_matrix$condition <- dds$condition
# IMPORTANT: ALS = 1 (Dysfunctional), Control = 0 (Normal)
feature_matrix$label <- ifelse(feature_matrix$condition == "ALS", 1, 0)

# Feature Selection (Top 100 genes by L2FC)
gene_importance <- sig_genes[sig_gene_ids, ] %>%
  arrange(desc(abs(log2FoldChange)))
top_genes <- rownames(gene_importance)[1:min(100, nrow(gene_importance))]

X <- feature_matrix[, top_genes]
y <- factor(feature_matrix$label, levels = c(0, 1), labels = c("Control", "ALS"))

# Training with LOOCV (Leave-One-Out, best for n=18)
ctrl <- trainControl(method = "LOOCV", savePredictions = "final", classProbs = TRUE, summaryFunction = twoClassSummary)

cat("\n🤖 Training Random Forest on ALS vs Control...\n")
set.seed(42)
model_rf <- train(x = X, y = y, method = "rf", trControl = ctrl, metric = "ROC")

# Calculate Dysfunction Score (0-100)
predictions_all <- predict(model_rf, X, type = "prob")
all_scores <- data.frame(
  sample = rownames(feature_matrix),
  condition = feature_matrix$condition,
  ml_dysfunction_score = round(predictions_all$ALS * 100, 1)
)

# Save Results
write.csv(all_scores, file.path(MODELS_DIR, "dysfunction_scores_all_samples.csv"), row.names = FALSE)
saveRDS(model_rf, file.path(MODELS_DIR, "dysfunction_score_model.rds"))

# Feature Importance
rf_imp <- varImp(model_rf)$importance
feature_imp <- data.frame(gene = rownames(rf_imp), importance = rf_imp$Overall) %>% arrange(desc(importance))
write.csv(feature_imp, file.path(MODELS_DIR, "feature_importance.csv"), row.names = FALSE)

# Visualization 1: Score Barplot
p1 <- ggplot(all_scores, aes(x = reorder(sample, ml_dysfunction_score), y = ml_dysfunction_score, fill = condition)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("ALS" = "#E74C3C", "Control" = "#3498DB")) +
  labs(title = "TDP-43 Dysfunction Score: ALS Validation", y = "Dysfunction Score (0-100)") +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(FIGURES_DIR, "dysfunction_score_barplot.png"), p1, width = 8, height = 6)

cat("\n✅ Phase 5 Complete. Results saved to results/models/\n")
