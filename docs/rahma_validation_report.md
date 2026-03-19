# Validation Report: TDP-43 Project
**Author:** Rahma
**Date:** 2026-03-19

## Overview
This report documents the resolution of technical issues encountered during the TDP-43 Project RNA-seq analysis. It details specific technical hurdles encountered while setting up the pipeline on WSL, the reasons for these errors, and the corrective actions taken.

## Part 1: Bioinformatics Workflow Troubleshooting
### 1. Drive Mounting and File System Errors
* **The Error:** `fatal: failed to stat '/mnt/h/KAUST/tdp43-dysfunction-score': No such device`.
* **The Reason:** The external H: drive was not properly mounted in WSL, often due to a system restart or a "ghost" connection.
* **The Fix:** Forcefully unmounted "ghost" connections using `sudo umount -l /mnt/h`, re-created the mount point, and remounted with explicit `drvfs` permissions.

### 2. WSL Command Syntax Error
* **The Error:** `Unknown command: shutdown`.
* **The Reason:** Attempted to execute a Windows-level management command (`wsl --shutdown`) from within the Linux terminal.
* **The Fix:** These commands must be executed from Windows PowerShell or Command Prompt, not the bash terminal.

### 3. Data Quality and Inconsistency
* **The Error:** `SRR10045019_2.fastq` was 17GB and uncompressed, leading to directory inconsistency.
* **The Reason:** A conversion process failed to complete the compression step.
* **The Fix:** Manually deleted inconsistent files (`rm -rf data/raw/SRR10045019*`) and re-ran `r_download_sra.sh`.

### 4. Salmon Indexing Warnings
* **The Warning:** Index built without decoy sequences and headers shorter than k-mer length 31.
* **The Reason:** Indexing was performed without providing a genome decoy for mapping accuracy.
* **The Fix:** Treated as non-fatal warnings for the current successful index. Recommended adding the `--decoys` flag for future refinements.

## Part 2: Script Evolution and Optimization
The scripts evolved from basic functional versions to robust pipelines as a direct response to the errors above.

### 1. download_sra.sh (Environmental Awareness)
* **Almokhtar's code:** `cd ~/tdp43-dysfunction-score` 
* **Rahma's code:** `echo "Working in: $(pwd)"` 
* **Impact:** Prevents filling the C: drive if the H: drive mount fails.

### 2. build_salmon_index.sh (Path Agnosticism) 
* **Almokhtar's code:** `cd ~/tdp43-dysfunction-score` 
* **Rahma's code:** *(Removed hardcoded cd, uses relative paths)*
* **Impact:** Allows the script to run regardless of the physical mount point.

### 3. run_salmon_quant.sh (Metadata Mapping) 
* **Almokhtar's code:** `for SAMPLE in "${ALL_SAMPLES[@]}"`
* **Rahma's code:** `for i in "${!SAMPLES[@]}"; do NAME=${NAMES[$i]}` 
* **Impact:** Maps SRR IDs to biological names ("KO-1") for better tracking of samples.

### 4. run_deseq2.R (Data Integrity)
* **Almokhtar's code:** `txi <- tximport(files, type="salmon", tx2gene=tx2gene)` 
* **Rahma's code:** `txi <- readRDS("data/processed/genome_wide_txi.rds")` 
* **Impact:** Ensures the analysis uses validated, pre-processed data instantly.

### 5. run_enrichment.R (Defensive Programming) 
* **Almokhtar's code:** `kegg_up <- enrichKEGG(gene = up_entrez, ...)` 
* **Rahma's code:** `kegg_up <- try(enrichKEGG(gene = up_entrez, ...), silent = TRUE)`
* **Impact:** Prevents pipeline failure during network/server outages.

## Current Status
- Scripts organized in `scripts/Rahmas_script`.
- Salmon index built and validated.
- Data integrity verified for all 6 samples.
- **Note:** Analysis results remain identical between the first and second versions of the scripts; optimization was focused strictly on code robustness, path flexibility, and error handling. 
