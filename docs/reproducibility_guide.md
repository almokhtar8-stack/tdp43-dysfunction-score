# Reproducibility Guide: TDP-43 RNA-Seq Analysis
**Project:** Analysis of Chromosome 14 RNA signaling (ALS/FTD)

## 1. Environment Setup
This project runs on Windows Subsystem for Linux (WSL2) with Ubuntu.

### Conda Environment
To recreate the exact computational environment:
```bash
conda create -n genomics python=3.9
conda activate genomics
conda install -c bioconda salmon fastqc deseq2 bioconductor-tximport
