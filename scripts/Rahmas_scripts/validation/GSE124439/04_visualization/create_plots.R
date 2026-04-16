#!/usr/bin/env Rscript
# DESeq2 Visualization for GSE124439
# Date: April 16, 2026
# Purpose: Generate publication-quality plots

cat("==================================================\n")
cat("DESeq2 Visualization - GSE124439 (ALS vs Control)\n")
cat("==================================================\n\n")

# Load libraries
suppressPackageStartupMessages({
  library(DESeq2)
  library(ggplot2)
  library(pheatmap)
  library(RColorBrewer)
  library(dplyr)
  library(tidyr)
  library(tibble)
})

# Define Absolute Paths
PROJECT_DIR <- "/mnt/h/KAUST/tdp43-dysfunction-score"
BASE_DIR <- file.path(PROJECT_DIR, "scripts/Rahmas_scripts/validation/GSE124439")
MODEL_PATH <- file.path(BASE_DIR, "results/models/GSE124439_dds.rds")
FIGURES_DIR <- file.path(BASE_DIR, "results/figures")

cat("Loading DESeq2 object...\n")
# Load DESeq2 object from Step 03
dds <- readRDS(MODEL_PATH)
cat("  - Loaded:", nrow(dds), "genes,", ncol(dds), "samples\n\n")

# Get results (ALS vs Control)
res <- results(dds, contrast = c("condition", "ALS", "Control"))

# Create output directory
dir.create(FIGURES_DIR, recursive = TRUE, showWarnings = FALSE)

# ============================================
# PLOT 1: PCA PLOT
# ============================================

cat("Creating Plot 1: PCA...\n")

# Variance stabilizing transformation
vsd <- vst(dds, blind = FALSE)

# PCA data
pcaData <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

# Enhanced PCA plot
p1 <- ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, label = name)) +
  geom_point(size = 5, alpha = 0.8) +
  geom_text(vjust = -1, size = 3, show.legend = FALSE) +
  scale_color_manual(values = c("Control" = "#2ECC71", "ALS" = "#E74C3C"),
                     labels = c("Control" = "Control (n=9)", "ALS" = "ALS (n=9)")) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  labs(
    title = "PCA Plot: GSE124439",
    subtitle = "Variance Stabilized Transformation",
    color = "Condition"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 10),
    legend.position = "bottom"
  )

ggsave(file.path(FIGURES_DIR, "pca_plot.png"), p1, width = 8, height = 6, dpi = 300)
cat("  ✓ Saved:", file.path(FIGURES_DIR, "pca_plot.png"), "\n\n")

# ============================================
# PLOT 2: VOLCANO PLOT
# ============================================

cat("Creating Plot 2: Volcano Plot...\n")

# Prepare data
volcano_data <- as.data.frame(res) %>%
  rownames_to_column("gene_id") %>%
  mutate(
    significant = case_when(
      padj < 0.05 & log2FoldChange > 1 ~ "Upregulated in ALS",
      padj < 0.05 & log2FoldChange < -1 ~ "Downregulated in ALS",
      TRUE ~ "Not Significant"
    ),
    significant = factor(significant, 
                        levels = c("Upregulated in ALS", 
                                   "Downregulated in ALS", 
                                   "Not Significant"))
  ) %>%
  filter(!is.na(padj))

# Count significant genes
up_count <- sum(volcano_data$significant == "Upregulated in ALS")
down_count <- sum(volcano_data$significant == "Downregulated in ALS")

p2 <- ggplot(volcano_data, aes(x = log2FoldChange, y = -log10(padj), 
                                color = significant)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c(
    "Upregulated in ALS" = "#E74C3C",
    "Downregulated in ALS" = "#3498DB",
    "Not Significant" = "gray70"
  )) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "gray30") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "gray30") +
  labs(
    title = "Volcano Plot: ALS vs Control",
    subtitle = paste0("Upregulated: ", up_count, " | Downregulated: ", down_count),
    x = "log2 Fold Change (ALS / Control)",
    y = "-log10(adjusted p-value)",
    color = "Significance"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 10),
    legend.position = "bottom"
  ) +
  xlim(c(-8, 8))

ggsave(file.path(FIGURES_DIR, "volcano_plot.png"), p2, width = 10, height = 8, dpi = 300)
cat("  ✓ Saved:", file.path(FIGURES_DIR, "volcano_plot.png"), "\n\n")

# ============================================
# PLOT 3: MA PLOT
# ============================================

cat("Creating Plot 3: MA Plot...\n")

ma_data <- as.data.frame(res) %>%
  rownames_to_column("gene_id") %>%
  mutate(
    significant = ifelse(padj < 0.05 & abs(log2FoldChange) > 1, 
                        "Significant", "Not Significant")
  ) %>%
  filter(!is.na(padj) & !is.na(baseMean) & baseMean > 0)

p3 <- ggplot(ma_data, aes(x = log10(baseMean), y = log2FoldChange, 
                          color = significant)) +
  geom_point(alpha = 0.5, size = 1) +
  scale_color_manual(values = c("Significant" = "#E74C3C", 
                               "Not Significant" = "gray70")) +
  geom_hline(yintercept = 0, linetype = "solid", color = "blue", linewidth = 0.5) +
  geom_hline(yintercept = c(-1, 1), linetype = "dashed", color = "gray30") +
  labs(
    title = "MA Plot: ALS vs Control",
    subtitle = "Log2 Fold Change vs Mean Expression",
    x = "log10(Mean Expression)",
    y = "log2 Fold Change (ALS / Control)",
    color = "Status"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 10),
    legend.position = "bottom"
  )

ggsave(file.path(FIGURES_DIR, "ma_plot.png"), p3, width = 10, height = 8, dpi = 300)
cat("  ✓ Saved:", file.path(FIGURES_DIR, "ma_plot.png"), "\n\n")

# ============================================
# PLOT 4: HEATMAP (Top 50 DE Genes)
# ============================================

cat("Creating Plot 4: Heatmap (Top 50 genes)...\n")

# Get top 50 significant genes by padj
top_genes <- as.data.frame(res) %>%
  rownames_to_column("gene_id") %>%
  filter(!is.na(padj)) %>%
  arrange(padj) %>%
  head(50) %>%
  pull(gene_id)

# Extract normalized counts
mat <- assay(vsd)[top_genes, ]

# Scale rows (z-score)
mat_scaled <- t(scale(t(mat)))

# Annotation
annotation_col <- data.frame(
  Condition = colData(dds)$condition,
  row.names = colnames(mat)
)

# Color palette
ann_colors <- list(
  Condition = c(ALS = "#E74C3C", Control = "#2ECC71")
)

# Create heatmap
png(file.path(FIGURES_DIR, "heatmap_top50.png"), width = 10, height = 12, 
    units = "in", res = 300)

pheatmap(mat_scaled,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = TRUE,
         show_colnames = TRUE,
         annotation_col = annotation_col,
         annotation_colors = ann_colors,
         color = colorRampPalette(c("blue", "white", "red"))(100),
         main = "Top 50 Differentially Expressed Genes\nALS vs Control",
         fontsize = 8,
         fontsize_row = 6,
         fontsize_col = 10,
         border_color = NA)

dev.off()
cat("  ✓ Saved:", file.path(FIGURES_DIR, "heatmap_top50.png"), "\n\n")

# ============================================
# PLOT 5: EXPRESSION BOXPLOTS (Top 5 Genes)
# ============================================

cat("Creating Plot 5: Expression Boxplots (Top 5 genes)...\n")

# Get top 5 genes
top5_genes <- as.data.frame(res) %>%
  rownames_to_column("gene_id") %>%
  filter(!is.na(padj)) %>%
  arrange(padj) %>%
  head(5) %>%
  pull(gene_id)

# Extract normalized counts
counts_norm <- counts(dds, normalized = TRUE)
top5_counts <- counts_norm[top5_genes, ]

# Prepare data for plotting
plot_data <- as.data.frame(t(top5_counts)) %>%
  rownames_to_column("sample") %>%
  pivot_longer(cols = -sample, names_to = "gene_id", values_to = "count") %>%
  mutate(condition = colData(dds)[sample, "condition"])

# Create boxplot
p5 <- ggplot(plot_data, aes(x = gene_id, y = log2(count + 1), fill = condition)) +
  geom_boxplot(alpha = 0.7) +
  geom_point(position = position_jitterdodge(jitter.width = 0.1), 
             size = 2, alpha = 0.8) +
  scale_fill_manual(values = c("ALS" = "#E74C3C", "Control" = "#2ECC71")) +
  labs(
    title = "Top 5 Differentially Expressed Genes",
    subtitle = "Normalized counts (log2 scale)",
    x = "Gene ID",
    y = "log2(Normalized Count + 1)",
    fill = "Condition"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = 10),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )

ggsave(file.path(FIGURES_DIR, "boxplot_top5.png"), p5, width = 12, height = 8, dpi = 300)
cat("  ✓ Saved:", file.path(FIGURES_DIR, "boxplot_top5.png"), "\n\n")

# ============================================
# SUMMARY
# ============================================

cat("==================================================\n")
cat("✓ All Plots Generated!\n")
cat("==================================================\n\n")

cat("Output files in:", FIGURES_DIR, "\n")
cat("  1. pca_plot.png\n")
cat("  2. volcano_plot.png\n")
cat("  3. ma_plot.png\n")
cat("  4. heatmap_top50.png\n")
cat("  5. boxplot_top5.png\n\n")

cat("PCA Summary:\n")
cat("  - PC1 explains", percentVar[1], "% of variance\n")
cat("  - PC2 explains", percentVar[2], "% of variance\n\n")

cat("Differential Expression Summary:\n")
cat("  - Upregulated in ALS:", up_count, "genes\n")
cat("  - Downregulated in ALS:", down_count, "genes\n\n")
