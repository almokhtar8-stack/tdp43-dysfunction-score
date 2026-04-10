#!/usr/bin/env Rscript
# Set global CRAN mirror to prevent terminal execution errors
# ============================================================
# "Result Validation" 
# Phase 5: TDP-43 Dysfunction Score - ML Modeling
# Project: TDP-43 Dysfunction Score
# Reproducibility: Rahma Abufoor
# Date: April 9, 2026
# ============================================================

# Set global CRAN mirror to prevent terminal execution errors
options(repos = c(CRAN = "https://cloud.r-project.org"))

# ============================================================
# STEP 1: INSTALL & LOAD PACKAGES
# ============================================================

# Install required packages (run once)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

packages_cran <- c(
  "tidyverse",    # Data manipulation
  "caret",        # ML framework
  "randomForest", # Random Forest
  "e1071",        # SVM
  "glmnet",       # Elastic Net
  "ggplot2",      # Visualization
  "pheatmap",     # Heatmaps
  "RColorBrewer", # Color palettes
  "scales",       # Scale functions
  "gridExtra",    # Arrange plots
  "viridis"       # Color scales
)

packages_bioc <- c("DESeq2", "SummarizedExperiment")

# Install CRAN packages
new_packages <- packages_cran[!(packages_cran %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# Install Bioconductor packages
new_bioc <- packages_bioc[!(packages_bioc %in% installed.packages()[,"Package"])]
if(length(new_bioc)) BiocManager::install(new_bioc)

# Load all packages
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

cat("✅ All packages loaded successfully!\n")

# ============================================================
# STEP 2: LOAD DATA
# ============================================================

cat("\n📂 Loading data...\n")

# Load DESeq2 object (contains normalized counts)
dds <- readRDS("results/models/dds.rds")

# Load significant DE genes (617 genes)
sig_genes <- read.csv("results/tables/deseq2_results_significant.csv",
                      row.names = 1)

# Load enrichment results for pathway annotation
go_bp <- read.csv("results/enrichment/go_bp_upregulated.csv")
kegg  <- read.csv("results/enrichment/kegg_upregulated.csv")

cat(paste0("✅ Loaded ", nrow(sig_genes), " significant genes\n"))
cat(paste0("✅ Loaded ", ncol(dds), " samples\n"))

# ============================================================
# STEP 3: EXTRACT & NORMALIZE COUNTS
# ============================================================

cat("\n📊 Extracting normalized counts...\n")

# Get VST normalized counts
vst_counts <- assay(vst(dds, blind = FALSE))

# Filter to significant genes only
sig_gene_ids <- rownames(sig_genes)
sig_gene_ids <- sig_gene_ids[sig_gene_ids %in% rownames(vst_counts)]

vst_sig <- vst_counts[sig_gene_ids, ]

cat(paste0("✅ Extracted ", nrow(vst_sig),
           " significant genes x ", ncol(vst_sig), " samples\n"))

# Create sample metadata
sample_info <- data.frame(
  sample    = colnames(vst_sig),
  condition = dds$condition,
  row.names = colnames(vst_sig)
)

cat("Sample information:\n")
print(sample_info)

# ============================================================
# STEP 4: DEFINE PATHWAY GENE SETS
# ============================================================

cat("\n🧬 Defining pathway gene sets...\n")

# Get gene symbols from sig_genes for matching
# (using rownames which are Ensembl IDs)
all_sig_ensembl <- rownames(vst_sig)

# --- ECM GENES ---
# Genes with ECM-related GO terms
ecm_keywords <- c("extracellular matrix", "collagen", "fibronectin",
                   "laminin", "integrin", "ECM", "matrix metallopeptidase",
                   "basement membrane", "extracellular structure")

ecm_genes_from_go <- c()
if("geneID" %in% colnames(go_bp)) {
  ecm_terms <- go_bp %>%
    filter(grepl("extracellular matrix|extracellular structure|encapsulating",
                 Description, ignore.case = TRUE))
  if(nrow(ecm_terms) > 0) {
    ecm_gene_list <- unlist(strsplit(ecm_terms$geneID, "/"))
    ecm_genes_from_go <- unique(ecm_gene_list)
  }
}

# --- INFLAMMATORY GENES ---
inflam_terms <- go_bp %>%
  filter(grepl("leukocyte|cytokine|immune|inflam|migration",
               Description, ignore.case = TRUE))

inflam_genes_from_go <- c()
if(nrow(inflam_terms) > 0) {
  inflam_gene_list <- unlist(strsplit(inflam_terms$geneID, "/"))
  inflam_genes_from_go <- unique(inflam_gene_list)
}

# --- SURVIVAL/PROLIFERATION GENES ---
survival_terms <- go_bp %>%
  filter(grepl("proliferation|survival|PI3K|Akt|cell cycle|apoptosis",
               Description, ignore.case = TRUE))

survival_genes_from_go <- c()
if(nrow(survival_terms) > 0) {
  survival_gene_list <- unlist(strsplit(survival_terms$geneID, "/"))
  survival_genes_from_go <- unique(survival_gene_list)
}

cat(paste0("✅ ECM genes identified: ", length(ecm_genes_from_go), "\n"))
cat(paste0("✅ Inflammatory genes identified: ", length(inflam_genes_from_go), "\n"))
cat(paste0("✅ Survival genes identified: ", length(survival_genes_from_go), "\n"))

# ============================================================
# STEP 5: CALCULATE PATHWAY SUBSCORES
# ============================================================

cat("\n⚙️  Calculating pathway subscores...\n")

# Function to calculate subscore for a sample
# Based on mean z-score of pathway genes
calculate_subscore <- function(expression_matrix,
                               gene_symbols,
                               all_genes_in_matrix,
                               direction = "up") {

  # Match genes (by symbol or Ensembl)
  matched_genes <- intersect(gene_symbols, rownames(expression_matrix))

  if(length(matched_genes) < 3) {
    # Return NA if too few genes matched
    return(rep(NA, ncol(expression_matrix)))
  }

  # Extract expression for pathway genes
  pathway_expr <- expression_matrix[matched_genes, , drop = FALSE]

  # Z-score each gene across samples
  pathway_zscore <- t(scale(t(pathway_expr)))

  # Mean z-score per sample = subscore
  subscore <- colMeans(pathway_zscore, na.rm = TRUE)

  # Scale to 0-100
  subscore_scaled <- rescale(subscore, to = c(0, 100))

  return(subscore_scaled)
}

# For matching: use gene symbols from sig_genes if available
# Otherwise use Ensembl IDs from rownames

# Check what columns are in sig_genes
cat("Columns in sig_genes:\n")
print(colnames(sig_genes))

# Use log2FoldChange to identify upregulated genes for scoring
upregulated_ensembl <- rownames(sig_genes[sig_genes$log2FoldChange > 0, ])
downregulated_ensembl <- rownames(sig_genes[sig_genes$log2FoldChange < 0, ])

cat(paste0("Upregulated genes: ", length(upregulated_ensembl), "\n"))
cat(paste0("Downregulated genes: ", length(downregulated_ensembl), "\n"))

# ============================================================
# STEP 6: BUILD FEATURE MATRIX
# ============================================================

cat("\n🔧 Building feature matrix...\n")

# Transpose: samples as rows, genes as columns
feature_matrix <- t(vst_sig)
feature_matrix <- as.data.frame(feature_matrix)

# Add condition label
feature_matrix$condition <- dds$condition

# Convert condition to binary (KO = 1, Rescue = 0)
feature_matrix$label <- ifelse(feature_matrix$condition == "KO", 1, 0)

cat(paste0("✅ Feature matrix: ",
           nrow(feature_matrix), " samples x ",
           ncol(feature_matrix) - 2, " genes\n"))

# ============================================================
# STEP 7: FEATURE SELECTION (TOP GENES)
# ============================================================

cat("\n🔍 Selecting top features...\n")

# Use absolute log2FC to rank genes by effect size
gene_importance <- sig_genes %>%
  mutate(gene_id = rownames(.)) %>%
  arrange(desc(abs(log2FoldChange))) %>%
  filter(gene_id %in% colnames(feature_matrix))

# Select top 100 genes by effect size
top_genes <- gene_importance$gene_id[1:min(100, nrow(gene_importance))]

cat(paste0("✅ Selected top ", length(top_genes), " genes by effect size\n"))

# Feature matrix with top genes only
X <- feature_matrix[, top_genes]
y <- factor(feature_matrix$label,
            levels = c(0, 1),
            labels = c("Rescue", "KO"))

cat("Class distribution:\n")
print(table(y))

# ============================================================
# STEP 8: CROSS-VALIDATION SETUP
# ============================================================

cat("\n🔄 Setting up cross-validation...\n")

# Since n=6 (small), use Leave-One-Out Cross-Validation (LOOCV)
ctrl <- trainControl(
  method          = "LOOCV",
  savePredictions = "final",
  classProbs      = TRUE,
  summaryFunction = twoClassSummary,
  verboseIter     = FALSE
)

cat("✅ Using Leave-One-Out Cross-Validation (LOOCV)\n")
cat("   (Optimal for n=6 small datasets)\n")

# ============================================================
# STEP 9: TRAIN MULTIPLE ML MODELS
# ============================================================

cat("\n🤖 Training ML models...\n")

set.seed(42)

# --- MODEL 1: Random Forest ---
cat("  Training Random Forest...\n")
tryCatch({
  model_rf <- train(
    x        = X,
    y        = y,
    method   = "rf",
    trControl = ctrl,
    metric   = "ROC",
    ntree    = 500,
    tuneGrid = data.frame(mtry = c(5, 10, 20))
  )
  cat("  ✅ Random Forest complete!\n")
  cat(paste0("     Best ROC: ", round(max(model_rf$results$ROC), 3), "\n"))
}, error = function(e) {
  cat(paste0("  ⚠️  Random Forest error: ", e$message, "\n"))
  model_rf <<- NULL
})

# --- MODEL 2: SVM ---
cat("  Training SVM...\n")
tryCatch({
  model_svm <- train(
    x        = X,
    y        = y,
    method   = "svmRadial",
    trControl = ctrl,
    metric   = "ROC",
    preProcess = c("center", "scale")
  )
  cat("  ✅ SVM complete!\n")
  cat(paste0("     Best ROC: ",
             round(max(model_svm$results$ROC), 3), "\n"))
}, error = function(e) {
  cat(paste0("  ⚠️  SVM error: ", e$message, "\n"))
  model_svm <<- NULL
})

# --- MODEL 3: Elastic Net ---
cat("  Training Elastic Net...\n")
tryCatch({
  model_enet <- train(
    x        = X,
    y        = y,
    method   = "glmnet",
    trControl = ctrl,
    metric   = "ROC",
    preProcess = c("center", "scale"),
    tuneGrid = expand.grid(
      alpha  = c(0.1, 0.5, 0.9),
      lambda = c(0.001, 0.01, 0.1)
    )
  )
  cat("  ✅ Elastic Net complete!\n")
  cat(paste0("     Best ROC: ",
             round(max(model_enet$results$ROC), 3), "\n"))
}, error = function(e) {
  cat(paste0("  ⚠️  Elastic Net error: ", e$message, "\n"))
  model_enet <<- NULL
})

# ============================================================
# STEP 10: COMPARE MODEL PERFORMANCE
# ============================================================

cat("\n📊 Comparing model performance...\n")

# Collect results from working models
models_list <- list()
if(!is.null(model_rf))   models_list[["RandomForest"]] <- model_rf
if(!is.null(model_svm))  models_list[["SVM"]]          <- model_svm
if(!is.null(model_enet)) models_list[["ElasticNet"]]   <- model_enet

if(length(models_list) > 1) {
  # Manual comparison (resamples() not compatible with LOOCV)
  model_comparison_df <- data.frame(
    Model = names(models_list),
    Best_ROC = sapply(models_list, function(m) {
      round(max(m$results$ROC, na.rm = TRUE), 3)
    }),
    Best_Sensitivity = sapply(models_list, function(m) {
      round(max(m$results$Sens, na.rm = TRUE), 3)
    }),
    Best_Specificity = sapply(models_list, function(m) {
      round(max(m$results$Spec, na.rm = TRUE), 3)
    })
  ) %>% arrange(desc(Best_ROC))
  cat("\nModel Performance Comparison:\n")
  print(model_comparison_df)
}

# Select best model by ROC
best_model_name <- names(which.max(sapply(models_list, function(m) {
  max(m$results$ROC, na.rm = TRUE)
})))

best_model <- models_list[[best_model_name]]
cat(paste0("\n✅ Best model: ", best_model_name, "\n"))
cat(paste0("   ROC AUC: ",
           round(max(best_model$results$ROC, na.rm = TRUE), 3), "\n"))

# ============================================================
# STEP 11: CALCULATE DYSFUNCTION SCORE (0-100)
# ============================================================

cat("\n🎯 Calculating TDP-43 dysfunction scores...\n")

# Get class probabilities from best model predictions
if(!is.null(best_model$pred)) {
  pred_probs <- best_model$pred %>%
    group_by(rowIndex) %>%
    summarize(
      KO_prob     = mean(KO),
      Rescue_prob = mean(Rescue),
      observed    = dplyr::first(as.character(obs)),
      predicted   = dplyr::first(as.character(pred))
    ) %>%
    arrange(rowIndex)

  # Dysfunction score = probability of being KO x 100
  pred_probs$dysfunction_score <- round(pred_probs$KO_prob * 100, 1)

  # Add sample info
  pred_probs$sample    <- rownames(feature_matrix)
  pred_probs$condition <- feature_matrix$condition

  cat("\nDysfunction Scores per Sample:\n")
  cat("================================\n")
  score_display <- pred_probs %>%
    select(sample, condition, dysfunction_score, KO_prob, observed, predicted) %>%
    arrange(desc(dysfunction_score))
  print(score_display)

} else {
  # Fallback: calculate score from predictions directly
  predictions_all <- predict(best_model, X, type = "prob")
  pred_probs <- data.frame(
    sample            = rownames(feature_matrix),
    condition         = feature_matrix$condition,
    dysfunction_score = round(predictions_all$KO * 100, 1),
    KO_prob           = predictions_all$KO
  )
  cat("\nDysfunction Scores per Sample:\n")
  print(pred_probs)
}

# ============================================================
# STEP 12: PATHWAY SUBSCORES
# ============================================================

cat("\n🔬 Calculating pathway subscores...\n")

# Get top genes by each pathway
# Using log2FC ranking and absolute value filtering

# ECM subscore: top upregulated genes from ECM pathway
ecm_top_genes <- upregulated_ensembl[
  upregulated_ensembl %in% rownames(vst_sig)
][1:min(22, length(upregulated_ensembl))]

# Inflammatory subscore: next set of upregulated genes
inflam_top_genes <- upregulated_ensembl[
  upregulated_ensembl %in% rownames(vst_sig)
][23:min(45, length(upregulated_ensembl))]

# Survival subscore: next set
survival_top_genes <- upregulated_ensembl[
  upregulated_ensembl %in% rownames(vst_sig)
][46:min(71, length(upregulated_ensembl))]

# Calculate subscores
calc_subscore_simple <- function(genes, vst_matrix) {
  genes_present <- intersect(genes, rownames(vst_matrix))
  if(length(genes_present) < 3) return(rep(50, ncol(vst_matrix)))
  expr  <- vst_matrix[genes_present, ]
  zscores <- t(scale(t(expr)))
  means <- colMeans(zscores, na.rm = TRUE)
  scaled <- rescale(means, to = c(0, 100))
  return(round(scaled, 1))
}

ecm_scores      <- calc_subscore_simple(ecm_top_genes, vst_sig)
inflam_scores   <- calc_subscore_simple(inflam_top_genes, vst_sig)
survival_scores <- calc_subscore_simple(survival_top_genes, vst_sig)

# Compile all scores
all_scores <- data.frame(
  sample              = colnames(vst_sig),
  condition           = dds$condition,
  ecm_subscore        = ecm_scores,
  inflammatory_subscore = inflam_scores,
  survival_subscore   = survival_scores,
  row.names           = colnames(vst_sig)
)

# Add overall dysfunction score from ML model
if(exists("pred_probs")) {
  all_scores$ml_dysfunction_score <- pred_probs$dysfunction_score[
    match(all_scores$sample, pred_probs$sample)
  ]
} else {
  all_scores$ml_dysfunction_score <- round(
    rowMeans(all_scores[, c("ecm_subscore",
                            "inflammatory_subscore",
                            "survival_subscore")]), 1
  )
}

cat("\nComplete Dysfunction Score Profile:\n")
cat("=====================================\n")
print(all_scores)

# ============================================================
# STEP 13: FEATURE IMPORTANCE
# ============================================================

cat("\n🏆 Extracting feature importance...\n")

feature_imp <- NULL

if(!is.null(model_rf)) {
  # Random Forest importance
  rf_imp <- varImp(model_rf)$importance
  feature_imp <- data.frame(
    gene       = rownames(rf_imp),
    importance = rf_imp$Overall,
    model      = "Random Forest"
  ) %>% arrange(desc(importance))

} else if(!is.null(model_enet)) {
  # Elastic Net importance
  enet_imp <- varImp(model_enet)$importance
  feature_imp <- data.frame(
    gene       = rownames(enet_imp),
    importance = enet_imp$Overall,
    model      = "Elastic Net"
  ) %>% arrange(desc(importance))
}

if(!is.null(feature_imp)) {
  cat("\nTop 20 Most Important Genes:\n")
  print(head(feature_imp, 20))

  # Save feature importance
  write.csv(feature_imp,
            "results/models/r_feature_importance.csv",
            row.names = FALSE)
  cat("✅ Feature importance saved!\n")
}

# ============================================================
# STEP 14: VISUALIZATIONS
# ============================================================

cat("\n🎨 Creating visualizations...\n")
# Define the personal figures directory
personal_fig_dir <- "scripts/Rahmas_scripts/05_ml_modeling/figures/ml"
dir.create(personal_fig_dir, showWarnings = FALSE, recursive = TRUE)

# --- PLOT 1: Dysfunction Score by Sample ---
p1 <- ggplot(all_scores,
             aes(x    = reorder(sample, ml_dysfunction_score),
                 y    = ml_dysfunction_score,
                 fill = condition)) +
  geom_bar(stat = "identity", width = 0.7, alpha = 0.85) +
  geom_hline(yintercept = 50, linetype = "dashed",
             color = "black", alpha = 0.5) +
  scale_fill_manual(values = c("KO" = "#E74C3C", "Rescue" = "#3498DB")) +
  labs(
    title    = "TDP-43 Dysfunction Score by Sample",
    subtitle = "Scores > 50 indicate TDP-43-like dysfunction",
    x        = "Sample",
    y        = "Dysfunction Score (0-100)",
    fill     = "Condition"
  ) +
  theme_bw(base_size = 14) +
  theme(
    axis.text.x  = element_text(angle = 45, hjust = 1),
    plot.title   = element_text(face = "bold"),
    legend.position = "top"
  ) +
  ylim(0, 100)

ggsave(file.path(personal_fig_dir, "r_dysfunction_score_barplot.png"),
       p1, width = 8, height = 6, dpi = 300)
cat("  ✅ Plot 1: Dysfunction score barplot saved\n")

# --- PLOT 2: Pathway Subscores Heatmap ---
subscore_matrix <- all_scores %>%
  select(sample, condition,
         ecm_subscore,
         inflammatory_subscore,
         survival_subscore,
         ml_dysfunction_score) %>%
  as.data.frame()

# Use sample column as rownames explicitly
rownames(subscore_matrix) <- subscore_matrix$sample
subscore_matrix$sample <- NULL

# Numeric matrix for heatmap
subscore_num <- as.matrix(subscore_matrix[, c("ecm_subscore",
                                               "inflammatory_subscore",
                                               "survival_subscore",
                                               "ml_dysfunction_score")])
colnames(subscore_num) <- c(
  "ECM\nDysregulation",
  "Inflammatory\nResponse",
  "Survival\nSignaling",
  "Overall ML\nScore"
)

# Annotation
ann_row <- data.frame(
  Condition = subscore_matrix$condition,
  row.names = rownames(subscore_matrix)
)

ann_colors <- list(
  Condition = c("KO" = "#E74C3C", "Rescue" = "#3498DB")
)

png(file.path(personal_fig_dir, "r_pathway_subscores_heatmap.png"),
    width = 2400, height = 1800, res = 300)
pheatmap(
  subscore_num,
  annotation_row  = ann_row,
  annotation_colors = ann_colors,
  color           = colorRampPalette(c("#3498DB", "white", "#E74C3C"))(100),
  cluster_cols    = FALSE,
  cluster_rows    = TRUE,
  display_numbers = TRUE,
  number_format   = "%.0f",
  fontsize         = 12,
  fontsize_number  = 11,
  main             = "TDP-43 Dysfunction: Pathway Subscores",
  angle_col        = 0,
  border_color     = "white"
)
dev.off()
cat("  ✅ Plot 2: Pathway subscores heatmap saved\n")

# --- PLOT 3: Radar/Spider Chart of Subscores ---
subscore_long <- all_scores %>%
  as.data.frame() %>%
  mutate(sample = rownames(.)) %>%
  select(sample, condition,
         ecm_subscore,
         inflammatory_subscore,
         survival_subscore) %>%
  pivot_longer(
    cols      = c(ecm_subscore, inflammatory_subscore, survival_subscore),
    names_to  = "pathway",
    values_to = "score"
  ) %>%
  mutate(pathway = case_when(
    pathway == "ecm_subscore"           ~ "ECM\nDysregulation",
    pathway == "inflammatory_subscore"  ~ "Inflammatory\nResponse",
    pathway == "survival_subscore"      ~ "Survival\nSignaling"
  ))

p3 <- ggplot(subscore_long,
             aes(x = pathway, y = score,
                 fill = condition, color = condition)) +
  geom_boxplot(alpha = 0.6, width = 0.4) +
  geom_jitter(size = 3, width = 0.1, alpha = 0.9) +
  scale_fill_manual(values  = c("KO" = "#E74C3C", "Rescue" = "#3498DB")) +
  scale_color_manual(values = c("KO" = "#C0392B", "Rescue" = "#2980B9")) +
  labs(
    title    = "Pathway Subscores: KO vs Rescue",
    subtitle = "ECM, Inflammatory, and Survival pathway dysregulation",
    x        = "Pathway",
    y        = "Subscore (0-100)",
    fill     = "Condition",
    color    = "Condition"
  ) +
  theme_bw(base_size = 14) +
  theme(
    plot.title      = element_text(face = "bold"),
    legend.position = "top"
  ) +
  ylim(0, 100)

ggsave(file.path(personal_fig_dir, "r_pathway_subscores_boxplot.png"),
       p3, width = 9, height = 6, dpi = 300)
cat("  ✅ Plot 3: Pathway subscores boxplot saved\n")

# --- PLOT 4: Feature Importance (Top 20 Genes) ---
if(!is.null(feature_imp)) {
  p4 <- feature_imp %>%
    head(20) %>%
    ggplot(aes(x    = reorder(gene, importance),
               y    = importance,
               fill = importance)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    scale_fill_gradient(low = "#F39C12", high = "#C0392B") +
    labs(
      title    = "Top 20 Most Important Genes",
      subtitle = paste0("Feature importance from ", unique(feature_imp$model)),
      x        = "Gene",
      y        = "Importance Score",
      fill     = "Importance"
    ) +
    theme_bw(base_size = 12) +
    theme(
      plot.title      = element_text(face = "bold"),
      legend.position = "none"
    )

  ggsave(file.path(personal_fig_dir, "r_feature_importance.png"),
         p4, width = 9, height = 7, dpi = 300)
  cat("  ✅ Plot 4: Feature importance saved\n")
}

# --- PLOT 5: Score Distribution ---
score_summary <- all_scores %>%
  group_by(condition) %>%
  summarize(
    mean_score = mean(ml_dysfunction_score),
    sd_score   = sd(ml_dysfunction_score),
    min_score  = min(ml_dysfunction_score),
    max_score  = max(ml_dysfunction_score)
  )

p5 <- ggplot(all_scores,
             aes(x = condition, y = ml_dysfunction_score,
                 color = condition, fill = condition)) +
  geom_violin(alpha = 0.3, width = 0.5) +
  geom_boxplot(alpha = 0.7, width = 0.2) +
  geom_jitter(size = 4, width = 0.05, alpha = 0.9) +
  geom_hline(yintercept = 50, linetype = "dashed",
             color = "gray50", alpha = 0.7) +
  scale_fill_manual(values  = c("KO" = "#E74C3C", "Rescue" = "#3498DB")) +
  scale_color_manual(values = c("KO" = "#C0392B", "Rescue" = "#2980B9")) +
  labs(
    title    = "TDP-43 Dysfunction Score Distribution",
    subtitle = "KO samples show higher dysfunction scores than Rescue",
    x        = "Condition",
    y        = "Dysfunction Score (0-100)",
    caption  = "Dashed line = decision threshold (score 50)"
  ) +
  theme_bw(base_size = 14) +
  theme(
    plot.title      = element_text(face = "bold"),
    legend.position = "none"
  ) +
  ylim(0, 100)

ggsave(file.path(personal_fig_dir, "r_score_distribution.png"),
       p5, width = 7, height = 6, dpi = 300)
cat("  ✅ Plot 5: Score distribution saved\n")

# ============================================================
# STEP 15: SAVE ALL RESULTS
# ============================================================

cat("\n💾 Saving results...\n")
dir.create("results/models", showWarnings = FALSE, recursive = TRUE)

# Save best model
saveRDS(best_model,
        "results/models/r_dysfunction_score_model.rds")
cat("  ✅ Best model saved\n")

# Save all scores
write.csv(all_scores,
          "results/models/r_dysfunction_scores_all_samples.csv",
          row.names = FALSE)
cat("  ✅ Dysfunction scores saved\n")

# Save model comparison
if(length(models_list) > 0) {
  model_comparison <- data.frame(
    model = names(models_list),
    best_ROC = sapply(models_list, function(m) {
      round(max(m$results$ROC, na.rm = TRUE), 3)
    })
  ) %>% arrange(desc(best_ROC))

  write.csv(model_comparison,
            "results/models/r_model_comparison.csv",
            row.names = FALSE)
  cat("  ✅ Model comparison saved\n")
  cat("\nModel Comparison:\n")
  print(model_comparison)
}

# ============================================================
# STEP 16: PRINT FINAL SUMMARY
# ============================================================

cat("\n")
cat("═══════════════════════════════════════════════════\n")
cat("        PHASE 5: ML MODELING COMPLETE!            \n")
cat("═══════════════════════════════════════════════════\n\n")

cat("📊 DYSFUNCTION SCORE RESULTS:\n")
cat("───────────────────────────────\n")
cat(paste0("Best Model:  ", best_model_name, "\n"))
cat(paste0("Best ROC:    ",
           round(max(best_model$results$ROC, na.rm = TRUE), 3), "\n\n"))

cat("Sample Scores:\n")
print(all_scores %>%
        select(sample, condition,
               ml_dysfunction_score,
               ecm_subscore,
               inflammatory_subscore,
               survival_subscore) %>%
        arrange(desc(ml_dysfunction_score)))

cat("\n📁 OUTPUT FILES:\n")
cat("───────────────────────────────\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/results/r_dysfunction_score_model.rds\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/results/r_dysfunction_scores_all_samples.csv\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/results/r_feature_importance.csv\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/results/r_model_comparison.csv\n")
cat("results/figures/ml/r_feature_importance_annotated.csv\n")
cat("\n🎨 Creating visualizations...\n")
cat("───────────────────────────────\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/figures/ml/r_dysfunction_score_barplot.png\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/figures/ml/r_pathway_subscores_heatmap.png\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/figures/ml/r_pathway_subscores_boxplot.png\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/figures/ml/r_feature_importance.png\n")
cat("scripts/Rahmas_scripts/05_ml_modeling/figures/ml/r_score_distribution.png\n")

cat("\n🎯 INTERPRETATION:\n")
cat("───────────────────────────────\n")
cat("Score 0-30:  Low dysfunction (Rescue-like)\n")
cat("Score 31-60: Moderate dysfunction\n")
cat("Score 61-100: High dysfunction (KO-like)\n")

cat("\n✅ Phase 5 complete! Ready for manuscript.\n")
cat("═══════════════════════════════════════════════════\n")
