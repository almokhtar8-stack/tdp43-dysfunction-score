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

# Extract VST counts
vst_counts <- assay(vst(dds, blind = FALSE))
sig_gene_ids <- intersect(rownames(sig_genes), rownames(vst_counts))
vst_sig <- vst_counts[sig_gene_ids, ]

# Build Feature Matrix
feature_matrix <- as.data.frame(t(vst_sig))
feature_matrix$condition <- dds$condition
feature_matrix$label <- ifelse(feature_matrix$condition == "ALS", 1, 0)

# Feature Selection (Top 100 genes by L2FC)
gene_importance <- sig_genes[sig_gene_ids, ] %>% arrange(desc(abs(log2FoldChange)))
top_genes <- rownames(gene_importance)[1:min(100, nrow(gene_importance))]

X <- feature_matrix[, top_genes]
y <- factor(feature_matrix$label, levels = c(0, 1), labels = c("Control", "ALS"))

# Training with LOOCV
cat("\n🤖 Training Random Forest on ALS vs Control...\n")
ctrl <- trainControl(method = "LOOCV", savePredictions = "final", classProbs = TRUE, summaryFunction = twoClassSummary)
set.seed(42)
model_rf <- train(x = X, y = y, method = "rf", trControl = ctrl, metric = "ROC")

# 1. Overall Dysfunction Score
predictions_all <- predict(model_rf, X, type = "prob")
all_scores <- data.frame(
  sample = rownames(feature_matrix),
  condition = feature_matrix$condition,
  ml_dysfunction_score = round(predictions_all$ALS * 100, 1)
)

# 2. Pathway Subscores Logic
# Defining gene sets for Inflammation and ECM (Using your top predictors)
inflam_genes <- intersect(c("ENSG00000123999", "ENSG00000134460", "ENSG00000101439"), rownames(vst_counts))
ecm_genes <- intersect(c("ENSG00000105327", "ENSG00000164692", "ENSG00000134853"), rownames(vst_counts))

calc_subscore <- function(genes, mat) {
  if(length(genes) < 1) return(rep(0, ncol(mat)))
  scores <- colMeans(mat[genes, , drop=FALSE])
  return(rescale(scores, to = c(0, 100)))
}

all_scores$Inflammation_Score <- calc_subscore(inflam_genes, vst_counts)
all_scores$ECM_Score <- calc_subscore(ecm_genes, vst_counts)

# Save Data
write.csv(all_scores, file.path(MODELS_DIR, "dysfunction_scores_all_samples.csv"), row.names = FALSE)
saveRDS(model_rf, file.path(MODELS_DIR, "dysfunction_score_model.rds"))

# --- VISUALIZATIONS ---

# V1: Overall Barplot
p1 <- ggplot(all_scores, aes(x = reorder(sample, ml_dysfunction_score), y = ml_dysfunction_score, fill = condition)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("ALS" = "#E74C3C", "Control" = "#3498DB")) +
  labs(title = "TDP-43 Dysfunction Score: ALS Validation", y = "Score (0-100)", x = "Sample") +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(file.path(FIGURES_DIR, "dysfunction_score_barplot.png"), p1, width = 8, height = 6)

# V2: Pathway Subscores Heatmap
plot_mat <- as.matrix(all_scores[, c("Inflammation_Score", "ECM_Score")])
rownames(plot_mat) <- all_scores$sample
ann <- data.frame(Condition = all_scores$condition, row.names = all_scores$sample)
png(file.path(FIGURES_DIR, "pathway_subscores_heatmap.png"), width=800, height=600)
pheatmap(t(plot_mat), annotation_col = ann, main="Pathway Driver Breakdown", 
         color = colorRampPalette(c("navy", "white", "firebrick3"))(50))
dev.off()

# V3: Subscore Boxplot
sub_long <- all_scores %>% pivot_longer(cols=c(Inflammation_Score, ECM_Score), names_to="Pathway", values_to="Score")
p3 <- ggplot(sub_long, aes(x=Pathway, y=Score, fill=condition)) +
  geom_boxplot(alpha=0.7) + geom_jitter(position=position_jitterdodge()) +
  scale_fill_manual(values = c("ALS" = "#E74C3C", "Control" = "#3498DB")) +
  theme_minimal() + labs(title="Distribution of Biological Drivers")
ggsave(file.path(FIGURES_DIR, "pathway_subscores_boxplot.png"), p3, width=7, height=5)

# V4: Feature Importance (Top 20)
rf_imp <- varImp(model_rf)$importance
feature_imp <- data.frame(gene = rownames(rf_imp), importance = rf_imp$Overall) %>% arrange(desc(importance))
p4 <- ggplot(head(feature_imp, 20), aes(x=reorder(gene, importance), y=importance)) +
  geom_bar(stat="identity", fill="#2C3E50") + coord_flip() +
  theme_minimal() + labs(title="Top 20 Predictive Features", x="Ensembl ID", y="Importance")
ggsave(file.path(FIGURES_DIR, "feature_importance_plot.png"), p4, width=8, height=8)

# V5: Score Distribution Histogram
p5 <- ggplot(all_scores, aes(x=ml_dysfunction_score, fill=condition)) +
  geom_histogram(bins=15, alpha=0.6, position="identity") +
  scale_fill_manual(values = c("ALS" = "#E74C3C", "Control" = "#3498DB")) +
  theme_minimal() + labs(title="Score Distribution: Visualizing the Diagnostic Gap", x="Dysfunction Score")
ggsave(file.path(FIGURES_DIR, "score_distribution_histogram.png"), p5, width=7, height=5)

cat("\n✅ Phase 5 Complete. All diagnostic plots generated in results/figures/ml/\n")
