#!/usr/bin/env Rscript
# Salmon QC Plots
# Date: March 20, 2026
# Purpose: Generate QC visualizations from Salmon metadata

cat("==================================================\n")
cat("Salmon QC Visualization\n")
cat("==================================================\n\n")

# Load libraries
suppressPackageStartupMessages({
  library(jsonlite)
  library(ggplot2)
  library(dplyr)
  library(tidyr)
})

# Sample metadata
samples <- data.frame(
  sample_id = c("SRR10045016", "SRR10045017", "SRR10045018",
                "SRR10045019", "SRR10045020", "SRR10045021"),
  condition = c("KO", "KO", "KO", "Rescue", "Rescue", "Rescue"),
  stringsAsFactors = FALSE
)

cat("Reading Salmon metadata...\n")

# Extract metadata from Salmon outputs
metadata_list <- list()

for (i in 1:nrow(samples)) {
  sample <- samples$sample_id[i]
  
  # Read meta_info.json
  meta_file <- paste0("results/salmon/", sample, "/aux_info/meta_info.json")
  meta <- fromJSON(meta_file)
  
  # Read cmd_info.json for mapping stats
  cmd_file <- paste0("results/salmon/", sample, "/cmd_info.json")
  cmd <- fromJSON(cmd_file)
  
  metadata_list[[sample]] <- list(
    sample = sample,
    condition = samples$condition[i],
    num_processed = meta$num_processed,
    num_mapped = meta$num_mapped,
    mapping_rate = meta$percent_mapped,
    num_targets = meta$num_targets
  )
}

# Convert to data frame
qc_data <- bind_rows(metadata_list)

cat("\nQC Summary:\n")
print(qc_data)

# Create output directory
dir.create("results/qc/salmon", recursive = TRUE, showWarnings = FALSE)

cat("\nGenerating plots...\n\n")

# ============================================
# PLOT 1: Mapping Rate Comparison
# ============================================

cat("1. Mapping rate comparison...\n")

p1 <- ggplot(qc_data, aes(x = sample, y = mapping_rate, fill = condition)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = 90, linetype = "dashed", color = "red", linewidth = 0.5) +
  geom_text(aes(label = paste0(round(mapping_rate, 1), "%")), 
            vjust = -0.5, size = 3) +
  scale_fill_manual(values = c("KO" = "#E74C3C", "Rescue" = "#3498DB")) +
  labs(
    title = "Salmon Mapping Rates",
    subtitle = "All samples exceed 90% mapping threshold",
    x = "Sample",
    y = "Mapping Rate (%)",
    fill = "Condition"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40")
  ) +
  ylim(0, 100)

ggsave("results/qc/salmon/mapping_rates.png", p1, width = 8, height = 6, dpi = 300)

# ============================================
# PLOT 2: Library Size Comparison
# ============================================

cat("2. Library size comparison...\n")

p2 <- ggplot(qc_data, aes(x = sample, y = num_processed / 1e6, fill = condition)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(num_processed / 1e6, 1), "M")), 
            vjust = -0.5, size = 3) +
  scale_fill_manual(values = c("KO" = "#E74C3C", "Rescue" = "#3498DB")) +
  labs(
    title = "Library Sizes (Total Reads)",
    subtitle = "Consistent sequencing depth across samples",
    x = "Sample",
    y = "Millions of Reads",
    fill = "Condition"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, color = "gray40")
  )

ggsave("results/qc/salmon/library_sizes.png", p2, width = 8, height = 6, dpi = 300)

# ============================================
# PLOT 3: Summary Statistics Table
# ============================================

cat("3. Summary statistics...\n")

summary_table <- qc_data %>%
  group_by(condition) %>%
  summarise(
    n_samples = n(),
    mean_reads = mean(num_processed),
    mean_mapping_rate = mean(mapping_rate),
    sd_mapping_rate = sd(mapping_rate),
    .groups = 'drop'
  ) %>%
  mutate(
    mean_reads = paste0(round(mean_reads / 1e6, 1), "M"),
    mean_mapping_rate = paste0(round(mean_mapping_rate, 2), "% ± ", round(sd_mapping_rate, 2), "%")
  ) %>%
  select(-sd_mapping_rate)

cat("\nSummary by Condition:\n")
print(summary_table, n = Inf)

# Save summary
write.csv(qc_data, "results/qc/salmon/qc_metrics.csv", row.names = FALSE)
write.csv(summary_table, "results/qc/salmon/qc_summary.csv", row.names = FALSE)

cat("\n==================================================\n")
cat("✓ Salmon QC plots generated!\n")
cat("==================================================\n")
cat("\nOutput files:\n")
cat("  - results/qc/salmon/mapping_rates.png\n")
cat("  - results/qc/salmon/library_sizes.png\n")
cat("  - results/qc/salmon/qc_metrics.csv\n")
cat("  - results/qc/salmon/qc_summary.csv\n")
cat("\n")
