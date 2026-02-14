# TDP-43 Dysfunction Score: Genome-Wide RNA-seq Analysis

## 🎯 Project Overview

Genome-wide differential expression analysis of TDP-43 dysfunction using CRISPR KO vs Rescue, identifying transcriptomic signatures for machine learning-based dysfunction score development in ALS/FTD research.

---

## 👥 Team

**KAUST Academy Bioinformatics Project - February 2026**

- **Almokhtar Aljarodi** - Project Lead & Bioinformatics Analysis
- **Rahma Abufoor** - RNA-seq Analysis & Quality Control
- **Ahmed Bukhamsin** - Machine Learning Model Development
- **Omar Buqes** - Pathway Enrichment & Network Analysis
- **Zahra Almahal** - Manuscript Writing & Documentation

---

## 📊 Project Status

**Last Updated:** February 14, 2026

### Completed Phases ✅

- [x] **Phase 1: Data Download & Setup** (Feb 14, 2026)
  - Downloaded GSE136366 dataset (6 samples, 67GB)
  - Created tx2gene mapping (646,577 transcripts)
  - System verification complete

- [x] **Phase 2: Salmon Quantification** (Feb 14, 2026)
  - Built Salmon index (453,506 transcripts)
  - Quantified all 6 samples (avg 92.69% mapping rate)
  - Generated QC plots and metrics
  - Total reads processed: ~349M

- [x] **Phase 3: Differential Expression Analysis** (Feb 14, 2026)
  - DESeq2 analysis: 16,536 genes analyzed
  - Identified 617 significant genes (padj < 0.05, |log2FC| > 1)
  - 488 upregulated in KO (79%)
  - 129 downregulated in KO (21%)

- [x] **Phase 4: Visualization** (Feb 14, 2026)
  - PCA plot (84% variance on PC1)
  - Volcano plot (488 up, 129 down)
  - MA plot (normalization validation)
  - Heatmap (top 50 genes, hierarchical clustering)
  - Boxplot (top 5 genes, individual samples)

### In Progress / Pending ⚪

- [ ] **Phase 5: ML Modeling** (Ahmed - Next)
  - Feature selection from 617 DE genes
  - TDP-43 dysfunction score algorithm
  - Model validation

- [ ] **Phase 6: Pathway Enrichment** (Omar - Next)
  - GO term enrichment
  - KEGG pathway analysis
  - Network visualization

- [ ] **Phase 7: Manuscript Writing** (Zahra - Final)
  - Methods section
  - Results description
  - Discussion and figures

---

## 🧬 Dataset Information

**Source:** GEO Accession GSE136366  
**Publication:** Brown et al. (2020)  
**Design:** TDP-43 CRISPR KO (n=3) vs TDP-43 Rescue (n=3)  
**Cell Type:** HeLa cells  
**Platform:** Illumina HiSeq 2500  
**Read Type:** Paired-end, 2×76bp  
**Reference Genome:** Homo sapiens GRCh38 (Ensembl release 116)  
**Chromosomes Analyzed:** chr1-22, chrX (chrY excluded - female cells)

### Sample IDs

| Sample ID | Condition | SRA Accession |
|-----------|-----------|---------------|
| Sample 1 | KO | SRR10045016 |
| Sample 2 | KO | SRR10045017 |
| Sample 3 | KO | SRR10045018 |
| Sample 4 | Rescue | SRR10045019 |
| Sample 5 | Rescue | SRR10045020 |
| Sample 6 | Rescue | SRR10045021 |

---

## 📈 Key Results

### Quality Metrics
- **Average mapping rate:** 92.69% (excellent)
- **Total reads processed:** ~349 million
- **PCA PC1 variance:** 84% (strong biological signal)
- **Replicate correlation:** >0.95 (highly reproducible)

### Differential Expression
- **Total genes analyzed:** 16,536
- **Significant genes:** 617 (3.73%)
- **Upregulated in KO:** 488 (79%) - validates TDP-43 repressor function
- **Downregulated in KO:** 129 (21%)
- **Effect sizes:** log2FC ranges from -7 to +7

### Biological Interpretation
- TDP-43 primarily functions as transcriptional repressor
- Loss of TDP-43 → loss of repression → gene upregulation
- No batch effects or outliers detected
- Publication-quality data

---

## 📁 Repository Structure
```
tdp43-dysfunction-score/
├── data/
│   ├── raw/              # FASTQ files (67GB, local only)
│   ├── references/       # Ensembl genome/transcriptome (local only)
│   └── processed/        # Intermediate files
├── scripts/
│   ├── 00_setup/         # Download & tx2gene creation
│   ├── 01_quality_control/     # FastQC/MultiQC
│   ├── 02_quantification/      # Salmon index & quant
│   ├── 03_differential_expression/  # DESeq2 analysis
│   ├── 04_visualization/       # PCA, volcano, heatmap plots
│   ├── 05_ml_modeling/        # ML dysfunction score (pending)
│   └── 06_enrichment_analysis/ # GO/KEGG pathways (pending)
├── results/
│   ├── qc/              # Quality control reports
│   ├── salmon/          # Quantification outputs (local only)
│   ├── tables/          # DESeq2 results (CSV files)
│   ├── figures/         # Publication-quality plots (PNG)
│   └── models/          # Saved R objects (DESeq2)
├── docs/
│   ├── phase1_notes.md         # Data download documentation
│   ├── phase2_notes.md         # Quantification notes
│   ├── phase3_notes.md         # DESeq2 analysis
│   ├── phase4_notes.md         # Visualization details
│   ├── project_summary.md      # Overall project summary
│   └── genome_wide_workflow.md # Complete workflow checklist
└── README.md            # This file
```

---

## 🛠️ Analysis Pipeline

### 1. Data Acquisition
```bash
# Download SRA files
scripts/00_setup/download_sra.sh

# Download Ensembl references
scripts/00_setup/download_ensembl.sh

# Create tx2gene mapping
Rscript scripts/00_setup/create_tx2gene.R
```

### 2. Quality Control
```bash
# Run FastQC on all samples
bash scripts/01_quality_control/run_fastqc.sh

# Results: all samples >90% quality, no trimming needed
```

### 3. Quantification
```bash
# Build Salmon index
bash scripts/02_quantification/build_salmon_index.sh

# Quantify all samples
bash scripts/02_quantification/run_salmon_quant.sh

# Generate QC plots
Rscript scripts/02_quantification/salmon_qc_plots.R
```

### 4. Differential Expression
```bash
# Run DESeq2 analysis
Rscript scripts/03_differential_expression/run_deseq2.R

# Output: 617 significant genes identified
```

### 5. Visualization
```bash
# Generate all plots
Rscript scripts/04_visualization/create_plots.R

# Output: 5 publication-quality figures
```

---

## 📊 Output Files

### Quality Control
- `results/qc/fastqc/` - Individual FastQC reports
- `results/qc/multiqc/multiqc_report.html` - Aggregated QC report
- `results/qc/salmon/*.png` - Salmon QC plots

### Differential Expression Results
- `results/tables/deseq2_results_all.csv` - All 16,536 genes
- `results/tables/deseq2_results_significant.csv` - 617 significant genes
- `results/tables/genes_upregulated_in_KO.csv` - 488 genes
- `results/tables/genes_downregulated_in_KO.csv` - 129 genes
- `results/tables/deseq2_summary_stats.csv` - Summary statistics

### Visualizations
- `results/figures/pca_plot.png` - Sample clustering
- `results/figures/volcano_plot.png` - DE significance
- `results/figures/ma_plot.png` - Expression vs fold change
- `results/figures/heatmap_top50.png` - Top genes clustered
- `results/figures/boxplot_top5.png` - Individual gene expression

### R Objects
- `results/models/dds.rds` - DESeq2 dataset object

---

## 💻 Requirements

### Software
- R (≥4.0)
- Bioconductor packages: DESeq2, tximport
- CRAN packages: ggplot2, pheatmap, dplyr
- Salmon (≥1.10)
- FastQC (≥0.12)
- MultiQC (≥1.33)

### System Requirements
- Disk space: ~100 GB (for raw data)
- RAM: ≥16 GB recommended
- OS: Linux/Unix (tested on Ubuntu 24)

---

## 📚 Documentation

Complete documentation available in `docs/`:
- **phase1_notes.md** - Data download details
- **phase2_notes.md** - Salmon quantification logs
- **phase3_notes.md** - DESeq2 analysis summary
- **phase4_notes.md** - Visualization interpretation
- **project_summary.md** - Overall findings

---

## 🔬 Methods Summary

**RNA-seq Pipeline:**
1. Quality control: FastQC/MultiQC
2. Quantification: Salmon quasi-mapping (k-mer 31)
3. Differential expression: DESeq2 (VST normalization)
4. Thresholds: padj < 0.05 (FDR), |log2FC| > 1

**Statistical Analysis:**
- Normalization: Variance Stabilizing Transformation (VST)
- Multiple testing correction: Benjamini-Hochberg FDR
- Pre-filtering: Genes with ≥10 total reads
- Significance: Adjusted p-value < 0.05 + |log2FC| > 1

---

## 📖 References

### Dataset
Brown AL, et al. (2020). TDP-43 loss and ALS-risk SNPs drive mis-splicing and depletion of UNC13A. *Nature*. GEO: GSE136366

### Methods
- Love MI, et al. (2014). Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology*.
- Patro R, et al. (2017). Salmon provides fast and bias-aware quantification of transcript expression. *Nature Methods*.

---

## 📧 Contact

**Almokhtar Aljarodi**  
Email: almokhtaraljarodi@gmail.com  
GitHub: [@almokhtar8-stack](https://github.com/almokhtar8-stack)

**Repository:** https://github.com/almokhtar8-stack/tdp43-dysfunction-score

---

## 📄 License

This project is for academic research purposes.

---

**Project initiated:** February 11, 2026  
**Phases 1-4 completed:** February 14, 2026  
**Status:** Active Development
