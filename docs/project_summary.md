# TDP-43 Dysfunction Score - Project Summary

**Project:** Genome-wide analysis of TDP-43 dysfunction using CRISPR KO vs Rescue  
**Dataset:** GSE136366 (HeLa cells, chr1-22 + X)  
**Date:** Feb 14, 2026  
**Status:** Phases 1-4 Complete ✅

---

## Project Overview

Development of a machine learning-based TDP-43 dysfunction score to predict disease severity in ALS/FTD patients based on transcriptomic signatures.

---

## Completed Analysis Pipeline

### Phase 1: Data Acquisition ✅
- Downloaded 6 RNA-seq samples from SRA
- Created transcript-to-gene mapping
- Total data: 67GB raw FASTQ files

### Phase 2: Quantification ✅
- Salmon quasi-mapping
- Average mapping rate: 92.69%
- Total reads processed: ~349M
- Quality: Excellent (all samples >90%)

### Phase 3: Differential Expression ✅
- DESeq2 analysis
- 16,536 genes analyzed
- 617 significant genes identified
- Strong statistical power (many p ≈ 0)

### Phase 4: Visualization ✅
- 5 publication-quality plots
- PCA shows 84% variance on PC1
- Perfect condition separation
- No batch effects

---

## Key Findings

### 1. TDP-43 Function Validation
- **79% of DE genes upregulated in KO**
- Confirms TDP-43 role as transcriptional repressor
- Consistent with published literature

### 2. Experimental Quality
- High mapping rates (91.5-93.5%)
- Strong biological signal (84% PC1 variance)
- Tight replicate clustering
- No outliers or batch effects

### 3. Statistical Robustness
- 617 genes with padj < 0.05, |log2FC| > 1
- Extremely significant p-values
- Strong effect sizes (log2FC up to ±7)
- Reproducible across replicates

---

## Data Quality Metrics

| Metric | Value | Status |
|--------|-------|--------|
| Average mapping rate | 92.69% | ✅ Excellent |
| Total reads | 349M | ✅ Sufficient |
| PCA PC1 variance | 84% | ✅ Strong signal |
| Significant genes | 617 | ✅ Good power |
| Replicate correlation | >0.95 | ✅ Highly reproducible |

---

## Next Steps

### Phase 5: ML Modeling (Ahmed)
**Objective:** Develop TDP-43 dysfunction score

**Approach:**
1. Feature selection from 617 DE genes
2. Dimensionality reduction (PCA/UMAP)
3. Score calculation algorithm
4. Validation on independent datasets

**Expected Output:**
- Dysfunction score model (0-100 scale)
- Feature importance rankings
- Model performance metrics

### Phase 6: Pathway Enrichment (Omar)
**Objective:** Biological interpretation

**Approach:**
1. GO term enrichment (upregulated genes)
2. KEGG pathway analysis
3. Network analysis (protein-protein interactions)
4. Literature validation

**Expected Output:**
- Enriched pathway lists
- Network visualization
- Biological interpretation

### Phase 7: Manuscript (Zahra)
**Objective:** Publication preparation

**Sections:**
1. Introduction (TDP-43 in ALS/FTD)
2. Methods (RNA-seq pipeline)
3. Results (DE analysis + ML model)
4. Discussion (biological implications)

---

## Repository Structure
```
tdp43-dysfunction-score/
├── data/
│   ├── raw/              # FASTQ files (67GB, not in GitHub)
│   ├── references/       # Ensembl files (not in GitHub)
│   └── processed/        # (empty, for future use)
├── scripts/
│   ├── 00_setup/         # Download & setup scripts
│   ├── 01_quality_control/  # FastQC/MultiQC
│   ├── 02_quantification/   # Salmon
│   ├── 03_differential_expression/  # DESeq2
│   └── 04_visualization/    # Plotting
├── results/
│   ├── qc/              # QC reports & plots
│   ├── salmon/          # Quantifications (not in GitHub)
│   ├── tables/          # DE results (CSV)
│   ├── figures/         # Publication plots (PNG)
│   └── models/          # DESeq2 objects
├── docs/
│   ├── phase1_notes.md  # Phase documentation
│   ├── phase2_notes.md
│   ├── phase3_notes.md
│   ├── phase4_notes.md
│   └── genome_wide_workflow.md
└── README.md
```

---

## Team Contributions

| Team Member | Role | Phases |
|-------------|------|--------|
| Almokhtar | Lead, Data Analysis | 1-4 (Complete) |
| Rahma | RNA-seq Analysis | 1-4 (Support) |
| Ahmed | ML Modeling | 5 (In Progress) |
| Omar | Pathway Analysis | 6 (Pending) |
| Zahra | Manuscript Writing | 7 (Pending) |

---

## Publications & References

### Dataset
Brown et al. (2020). "TDP-43 loss of function and neurodegeneration"  
GEO: GSE136366

### Methods
- Love et al. (2014). DESeq2. Genome Biology.
- Patro et al. (2017). Salmon. Nature Methods.

---

## Contact

**Repository:** https://github.com/almokhtar8-stack/tdp43-dysfunction-score  
**Last Updated:** Feb 14, 2026
