cat << 'EOF' > rahma_validation_report.md
# Validation Report: TDP-43 Project
**Author:** Rahma
**Date: 2026-03-19**

## Overview
This report documents the resolution of technical issues encountered during the Chromosome 14 RNA-seq analysis[cite: 1, 2]. It details specific technical hurdles encountered while setting up the pipeline on WSL, the reasons for these errors, and the corrective actions taken[cite: 1].

## Part 1: Bioinformatics Workflow Troubleshooting
### 1. Drive Mounting and File System Errors
* **The Error:** `fatal: failed to stat '/mnt/h/KAUST/tdp43-dysfunction-score': No such device`[cite: 5, 6].
* **The Reason:** The external H: drive was not properly mounted in WSL, often due to a system restart or a "ghost" connection[cite: 6].
* **The Fix:** Forcefully unmounted "ghost" connections using `sudo umount -l /mnt/h`, re-created the mount point, and remounted with explicit `drvfs` permissions[cite: 7, 16, 19].

### 2. WSL Command Syntax Error
* **The Error:** `Unknown command: shutdown`[cite: 21, 22].
* **The Reason:** Attempted to execute a Windows-level management command (`wsl --shutdown`) from within the Linux terminal[cite: 23, 24].
* **The Fix:** These commands must be executed from Windows PowerShell or Command Prompt, not the bash terminal[cite: 25, 29].

### 3. Data Quality and Inconsistency
* **The Error:** `SRR10045019_2.fastq` was 17GB and uncompressed, leading to directory inconsistency[cite: 34, 35].
* **The Reason:** A conversion process failed to complete the compression step[cite: 35].
* **The Fix:** Manually deleted inconsistent files (`rm -rf data/raw/SRR10045019*`) and re-ran `r_download_sra.sh`[cite: 36, 45, 47].

### 4. Salmon Indexing Warnings
* **The Warning:** Index built without decoy sequences and headers shorter than k-mer length 31[cite: 51, 53].
* **The Reason:** Indexing was performed without providing a genome decoy for mapping accuracy[cite: 52, 54].
* **The Fix:** Treated as non-fatal warnings for the current successful index[cite: 55, 59]. Recommended adding the `--decoys` flag for future refinements[cite: 61, 62].

## Part 2: Script Evolution and Optimization
The scripts evolved from basic functional versions to robust pipelines as a direct response to the errors above[cite: 145, 175, 197].

### 1. download_sra.sh
* **Changes:** Added storage estimation (~25GB) and `pwd` verification[cite: 68, 73].
* **Impact:** Prevents crashes on the Surface Pro by ensuring sufficient space and correct drive mounting (H: vs C:)[cite: 69, 71, 75].

### 2. build_salmon_index.sh
* **Changes:** Moved to a minimalist, "path-agnostic" script by removing hardcoded dates and forced `cd` commands[cite: 122, 130, 133].
* **Impact:** Increases flexibility if the project folder is moved between different mount points[cite: 134, 143].

### 3. run_salmon_quant.sh
* **Changes:** Introduced centralized variables and parallel arrays to map SRR IDs to biological names (e.g., "KO-1")[cite: 149, 153].
* **Impact:** Improves maintainability and allows for better tracking of "Knockout" vs "Rescue" progress in logs[cite: 151, 155, 173].

### 4. run_deseq2.R
* **Changes:** Switched from manual `tximport` to loading pre-processed `.rds` files and added ML-ready normalization[cite: 178, 179, 188].
* **Impact:** Ensures the analysis starts instantly with validated data and prepares the dataset for future predictive modeling[cite: 181, 191].

### 5. run_enrichment.R
* **Changes:** Implemented `try()` blocks for KEGG enrichment and added server availability safe-checks[cite: 198, 201].
* **Impact:** Prevents script crashes during network flickers, ensuring GO analysis completes even if KEGG servers are down[cite: 199, 203, 205].

## Current Status
- Scripts organized in `scripts/Rahmas_script`[cite: 196].
- Salmon index built and validated[cite: 60].
- Data integrity verified for all 6 samples[cite: 86].
EOF
