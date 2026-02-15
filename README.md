# TDP-43 Dysfunction Score: Genome-Wide RNA-seq Analysis

## 🎯 Project Overview

Genome-wide differential expression analysis of TDP-43 dysfunction using CRISPR KO vs Rescue, identifying transcriptomic signatures for machine learning-based dysfunction score development in ALS/FTD research.

**Mission:** Develop a molecular biomarker for early detection, progression prediction, and treatment monitoring in ALS/FTD patients.

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

- [x] **Phase 6: Pathway Enrichment** (Feb 14, 2026)
  - GO/KEGG enrichment analysis
  - 22-gene ECM signature identified
  - Validates recent TDP-43-ECM findings
  - Identifies therapeutic targets

### In Progress / Pending ⚪

- [ ] **Phase 5: ML Modeling** (Ahmed - Next)
  - Feature selection from 617 DE genes
  - TDP-43 dysfunction score algorithm
  - Model validation

- [ ] **Phase 7: Manuscript Writing** (Zahra - Final)
  - Methods section
  - Results description
  - Discussion and figures

---

## 🔬 Key Biological Findings

### Pathway Enrichment Results (Phase 6)

**Top Finding: Extracellular Matrix Dysregulation**
- **22 genes** involved in ECM organization (p.adj = 0.009)
- ECM emerges as **#1 pathway** in unbiased genome-wide screen
- **Validates and extends** recent studies in endothelial cells and neurons

**Relationship to Literature:**

Recent independent studies show TDP-43 regulates ECM:
- **Endothelial cells:** Fernández-Galiana et al. (2024, JCI Insight), Hipke et al. (2023, Front Cell Dev Biol)
- **Motor neurons:** Cheung et al. (2024, Neurobiol Dis) - MMP-9 degrades perineuronal nets in Q331K mice
- **ALS patients:** Kaplan et al. (2024), Sun et al. (2020) - ECM genes enriched in motor neuron transcriptomics

**Our Unique Contribution:**
- ✅ Independent confirmation via **unbiased genome-wide screen**
- ✅ Extension to **non-vascular, non-neuronal** cell type (HeLa)
- ✅ **Complete CRISPR KO** (vs mutations/knockdowns)
- ✅ Specific **22-gene signature** for therapeutic targeting
- ✅ **Systems-level integration** (ECM + inflammation + survival)

**Convergent Evidence:**

Multiple independent studies now demonstrate ECM dysregulation with TDP-43 loss across:
- Different cell types (endothelial, neuronal, epithelial)
- Different species (human, mouse, zebrafish)
- Different methods (genetics, transcriptomics, imaging)

→ Strengthens ECM remodeling as a **core, conserved feature** of TDP-43 dysfunction

**Secondary Findings:**
- **Inflammatory response** activation (leukocyte migration, cytokines)
- **PI3K-Akt survival** signaling pathway
- **Cell adhesion** and proliferation pathways

---

## 🏥 Clinical & Therapeutic Implications

### Why This Matters for ALS/FTD Patients

**Current ALS/FTD Landscape:**
- ❌ No cure available (only 2 FDA-approved drugs with modest effects)
- ❌ Median survival: 2-5 years from diagnosis
- ❌ Late diagnosis: Symptoms appear after 50-80% motor neuron loss
- ❌ No biomarkers for progression prediction or treatment response

**Our 617-Gene Dysfunction Score Addresses:**

### 1. **Early Detection**
- Screen at-risk individuals (family history, TDP-43 mutations)
- Detect molecular dysfunction **before clinical symptoms**
- Intervene when more neurons are salvageable
- **Gain 1-2 years of treatment time**

### 2. **Progression Prediction**
- High score → severe dysfunction → fast progression
- Low score → mild dysfunction → slow progression  
- **Personalize treatment intensity** based on predicted course

### 3. **Treatment Monitoring**
- Objective measure of drug efficacy
- Detect response/failure within 3 months (vs 12 months clinically)
- Switch ineffective treatments faster

### 4. **Patient Stratification**
- Enrich clinical trials with high-dysfunction patients
- Smaller trials, faster results, higher success rate
- Match patients to mechanism-targeted drugs

---

## 💊 Therapeutic Targets Identified

### From Our Pathway Analysis:

**1. MMP Inhibitors** (ECM Stabilization)
- **Target:** Matrix metalloproteinases degrading ECM
- **Candidates:** Minocycline, doxycycline (already tested in ALS)
- **Mechanism:** Preserve protective ECM around neurons

**2. Anti-Inflammatory Drugs**
- **Target:** Leukocyte migration, cytokine signaling
- **Candidates:** Tocilizumab (IL-6 blocker), infliximab (TNF-α blocker)
- **Mechanism:** Reduce chronic neuroinflammation

**3. PI3K-Akt Modulators**
- **Target:** Cell survival pathway activation
- **Candidates:** Rapamycin (in clinical trials), insulin-like growth factor
- **Mechanism:** Enhance neuronal survival signals

**4. Combination Therapy**
- ECM stabilization + anti-inflammatory + survival enhancement
- **Biomarker-guided dosing** based on dysfunction score

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

### Pathway Enrichment (Phase 6)
- **Top pathway:** ECM organization (22 genes, p.adj = 0.009)
- **GO terms enriched:** 15 BP, 7 MF, 24 CC
- **KEGG pathways:** 6 (ECM-receptor, PI3K-Akt, focal adhesion, etc.)
- **Validates:** Emerging TDP-43-ECM link across cell types

### Biological Interpretation
- TDP-43 primarily functions as transcriptional repressor
- Loss of TDP-43 → ECM dysregulation + inflammation
- Convergent evidence across independent studies
- Therapeutic targets identified (MMP, cytokines, PI3K-Akt)

---

## 🚀 Translational Roadmap

### Stage 1: Model Development (Current - Phase 5)
**Timeline:** Months 1-3
- Ahmed develops ML dysfunction score from 617 genes
- Algorithm outputs 0-100 score quantifying TDP-43 pathology

### Stage 2: External Validation
**Timeline:** Months 4-6
- Test on independent TDP-43 datasets
- Validate in patient-derived cells (iPSCs)
- Optimize gene panel (reduce to 50-100 most important genes)

### Stage 3: Clinical Validation
**Timeline:** Year 2
- Recruit 100 ALS patients + 50 controls
- Blood transcriptomics → calculate score
- Correlate with 12-month clinical progression
- Submit to FDA for biomarker qualification

### Stage 4: Therapeutic Trials
**Timeline:** Years 3-5
- Biomarker-enriched Phase II trial
- Test MMP inhibitor + anti-inflammatory combination
- Primary endpoint: Dysfunction score change at 6 months
- Adaptive design based on score response

### Stage 5: Clinical Implementation
**Timeline:** Years 5-10
- Score becomes standard ALS biomarker
- Clinical-grade assay (qPCR panel)
- Insurance reimbursement
- Guide treatment decisions for every ALS patient

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
│   ├── 05_ml_modeling/        # ML dysfunction score (in progress)
│   └── 06_enrichment_analysis/ # GO/KEGG pathways (complete)
├── results/
│   ├── qc/              # Quality control reports
│   ├── salmon/          # Quantification outputs (local only)
│   ├── tables/          # DESeq2 results (CSV files)
│   ├── figures/         # Publication-quality plots (PNG)
│   ├── enrichment/      # Pathway analysis results
│   └── models/          # Saved R objects (DESeq2)
├── docs/
│   ├── phase1_notes.md         # Data download documentation
│   ├── phase2_notes.md         # Quantification notes
│   ├── phase3_notes.md         # DESeq2 analysis
│   ├── phase4_notes.md         # Visualization details
│   ├── phase6_notes.md         # Pathway enrichment
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

### 6. Pathway Enrichment
```bash
# Run enrichment analysis
Rscript scripts/06_enrichment_analysis/run_enrichment.R

# Output: GO/KEGG results + visualizations
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

### Pathway Enrichment Results
- `results/enrichment/go_bp_upregulated.csv` - GO Biological Process (15 terms)
- `results/enrichment/go_mf_upregulated.csv` - GO Molecular Function (7 terms)
- `results/enrichment/kegg_upregulated.csv` - KEGG pathways (6 pathways)
- `results/enrichment/go_bp_upregulated_barplot.png` - Visualization
- `results/enrichment/go_bp_upregulated_dotplot.png` - Gene ratios plot
- `results/enrichment/kegg_upregulated_barplot.png` - KEGG visualization

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
- Bioconductor packages: DESeq2, tximport, clusterProfiler, org.Hs.eg.db
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
- **phase6_notes.md** - Pathway enrichment analysis
- **project_summary.md** - Overall findings

---

## 🔬 Methods Summary

**RNA-seq Pipeline:**
1. Quality control: FastQC/MultiQC
2. Quantification: Salmon quasi-mapping (k-mer 31)
3. Differential expression: DESeq2 (VST normalization)
4. Pathway enrichment: clusterProfiler (GO/KEGG)
5. Thresholds: padj < 0.05 (FDR), |log2FC| > 1

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
- Yu G, et al. (2012). clusterProfiler: an R package for comparing biological themes among gene clusters. *OMICS*.

### TDP-43 & ECM Literature
- Fernández-Galiana I, et al. (2024). Endothelial TDP-43 controls sprouting angiogenesis and vascular barrier integrity. *JCI Insight*.
- Hipke K, et al. (2023). Loss of TDP-43 causes ectopic endothelial sprouting through increased fibronectin, vcam 1 and integrin α4/β1. *Front Cell Dev Biol*.
- Cheung SW, et al. (2024). Phagocytosis of aggrecan-positive perineuronal nets by MMP-9 expressing microglia in TDP-43Q331K mice. *Neurobiol Dis*.
- Kaplan A, et al. (2024). Meta-analysis of differential gene expression in ALS motor neurons. *Front Genet*.

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
**Phases 1-4, 6 completed:** February 14, 2026  
**Status:** Active Development

---

## 🎯 Impact Statement

**This research aims to transform ALS/FTD patient care by:**
- Enabling early detection before irreversible neuronal loss
- Predicting disease progression to personalize treatment
- Identifying therapeutic targets (ECM, inflammation, survival pathways)
- Accelerating drug development through biomarker-enriched trials
- Monitoring treatment response objectively and rapidly

**Ultimately: Helping ALS/FTD patients live longer, better lives.** 💙
