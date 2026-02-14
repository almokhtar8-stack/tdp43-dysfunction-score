# Phase 4: Visualization

**Date:** Feb 14, 2026  
**Script:** `scripts/04_visualization/create_plots.R`  
**Status:** ✅ COMPLETE  
**Runtime:** ~10 minutes

---

## Overview

Generated 5 publication-quality plots to visualize differential expression results from DESeq2 analysis (TDP-43 KO vs Rescue comparison).

---

## Plots Generated

### 1. PCA Plot (`pca_plot.png`)

**Purpose:** Assess sample clustering and batch effects

**Key Findings:**
- **PC1: 84% variance** - Excellent separation between KO and Rescue
- **PC2: 5% variance** - Secondary variation
- Perfect clustering by condition (no overlap)
- Tight replicate clustering (low technical variation)
- No outliers detected

**Interpretation:**
- Strong biological signal dominates the data
- Experimental groups are clearly distinct
- High quality, reproducible replicates

**Technical Details:**
- Method: Variance Stabilizing Transformation (VST)
- Top 500 most variable genes used
- Euclidean distance metric

---

### 2. Volcano Plot (`volcano_plot.png`)

**Purpose:** Visualize magnitude and significance of differential expression

**Key Findings:**
- **488 genes upregulated in KO** (red, right side)
- **129 genes downregulated in KO** (blue, left side)
- **Total significant:** 617 genes (padj < 0.05, |log2FC| > 1)
- Strong effect sizes (log2FC ranges from -7 to +7)
- Extremely significant p-values (many -log10(padj) > 200)

**Interpretation:**
- Majority upregulated in KO (79%) validates TDP-43 repressor function
- Loss of TDP-43 → loss of repression → gene upregulation
- Bimodal distribution suggests clear biological response
- Very strong statistical evidence (ultra-low p-values)

**Thresholds:**
- Vertical lines: log2FC = ±1
- Horizontal line: padj = 0.05

---

### 3. MA Plot (`ma_plot.png`)

**Purpose:** Assess expression-dependent bias and overall distribution

**Key Findings:**
- Symmetric distribution around log2FC = 0
- No expression-dependent bias (good normalization)
- Significant genes (red) distributed across expression levels
- Higher variance at low expression (expected)

**Interpretation:**
- DESeq2 normalization worked correctly
- No systematic technical artifacts
- Differential expression independent of expression level

**Technical Details:**
- X-axis: log10(mean normalized counts)
- Y-axis: log2(KO / Rescue)
- Horizontal lines: log2FC = ±1 thresholds

---

### 4. Heatmap - Top 50 Genes (`heatmap_top50.png`)

**Purpose:** Visualize expression patterns of most significant genes

**Key Findings:**
- **Top cluster (smaller):** 
  - Genes downregulated in KO (blue cells under KO samples)
  - Higher expression in Rescue (red cells under Rescue samples)
  - Corresponds to ~129 downregulated genes
  
- **Bottom cluster (larger):**
  - Genes upregulated in KO (red cells under KO samples)
  - Lower expression in Rescue (blue cells under Rescue samples)
  - Corresponds to ~488 upregulated genes

- Perfect sample clustering by condition
- Strong consistent patterns within replicates

**Color Scheme:**
- **Top annotation bar:** Condition (Red = KO, Blue = Rescue)
- **Heatmap cells:** Expression z-score (Red = high, Blue = low, White = medium)

**Technical Details:**
- Top 50 genes by adjusted p-value
- Row scaling: z-score normalization
- Clustering: Hierarchical, Euclidean distance
- Color gradient: Blue (low) → White (medium) → Red (high)

---

### 5. Expression Boxplot - Top 5 Genes (`boxplot_top5.png`)

**Purpose:** Show individual sample expression for most significant genes

**Top 5 Genes:**
1. **ENSG00000067057** - Downregulated in KO
2. **ENSG00000095319** - Downregulated in KO  
3. **ENSG00000113140** - Upregulated in KO
4. **ENSG00000116299** - Upregulated in KO
5. **ENSG00000120948** - Downregulated in KO

**Key Findings:**
- Clear separation between KO and Rescue for all genes
- Consistent patterns across replicates
- Individual points visible (transparency check)
- Log2 scale shows magnitude of change

**Technical Details:**
- Y-axis: log2(normalized count + 1)
- Points: Individual samples (jittered)
- Boxes: Quartile ranges

---

## Overall Biological Interpretation

### TDP-43 as a Transcriptional Repressor

**Evidence:**
1. **79% of DE genes upregulated in KO** (488/617)
2. Loss of TDP-43 → loss of repression → increased expression
3. Consistent with published TDP-43 biology

### Experimental Quality

**Strengths:**
- ✅ Strong biological signal (84% variance on PC1)
- ✅ Perfect sample clustering by condition
- ✅ Tight replicate clustering (low technical noise)
- ✅ No batch effects detected
- ✅ No outliers
- ✅ Symmetric distribution (good normalization)

### Statistical Power

**Metrics:**
- 617 significant genes at stringent thresholds
- Extremely low p-values (many approaching machine precision)
- Strong effect sizes (log2FC up to ±7)
- High reproducibility across replicates

---

## Output Files

### Location: `results/figures/`

| File | Size | Description |
|------|------|-------------|
| `pca_plot.png` | ~100 KB | PCA sample clustering |
| `volcano_plot.png` | ~150 KB | DE significance vs magnitude |
| `ma_plot.png` | ~150 KB | Expression-dependent bias check |
| `heatmap_top50.png` | ~200 KB | Top 50 gene patterns |
| `boxplot_top5.png` | ~80 KB | Individual sample expression |

**All plots:**
- Resolution: 300 DPI (publication quality)
- Format: PNG
- Dimensions: 8-12 inches width
- Color scheme: Colorblind-friendly

---

## Quality Control Checks

- [x] PCA shows clear separation
- [x] No batch effects detected
- [x] Replicates cluster tightly
- [x] MA plot symmetric (no bias)
- [x] Volcano plot shows expected distribution
- [x] Heatmap clustering makes biological sense
- [x] Individual genes show consistent patterns

---

## Next Steps

### Phase 5: ML Modeling (Ahmed)
- Feature engineering from 617 DE genes
- TDP-43 dysfunction score prediction
- Model training and validation

### Phase 6: Pathway Enrichment (Omar)
- GO term enrichment
- KEGG pathway analysis
- Biological interpretation
- Literature validation

### Phase 7: Manuscript Writing (Zahra)
- Methods section
- Results description
- Figure preparation
- Discussion of findings

---

## Technical Notes

### Software Versions
- DESeq2: Latest Bioconductor version
- ggplot2: Latest CRAN version
- pheatmap: Latest CRAN version

### Color Palettes
- Condition colors: Red (#E74C3C) for KO, Blue (#3498DB) for Rescue
- Heatmap gradient: Blue-White-Red (RColorBrewer)
- Volcano/MA: Red (significant), Gray (not significant)

### Statistical Thresholds
- Adjusted p-value: < 0.05 (Benjamini-Hochberg FDR)
- Log2 fold change: |log2FC| > 1 (2-fold change)
- Mean count filter: > 10 reads (from Phase 3)

---

## References

Analysis follows best practices from:
- Love MI, et al. (2014). Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology.
- PCA and VST methods from DESeq2 vignette
- Visualization principles from Tufte, "The Visual Display of Quantitative Information"
