# Validation Report: TDP-43 Dysfunction Score Project
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
---
## Part 2: Script Evolution and Optimization
The scripts evolved from basic functional versions to robust pipelines. These changes were made to improve error handling and environment awareness.

### 1. download_sra.sh
* **The Change:** Added environment verification and storage awareness.
* **Almokhtar's code:** `cd ~/tdp43-dysfunction-score`
* **Rahma's code:** `echo "Working in: $(pwd)"`
* **The Impact:** Prevents filling the internal C: drive if the H: drive mount fails and provides a visual check of the working directory.

### 2. build_salmon_index.sh
* **The Change:** Transitioned to path-agnostic execution.
* **Almokhtar's code:** `cd ~/tdp43-dysfunction-score`
* **Rahma's code:** *(Removed hardcoded cd, uses relative paths)*
* **The Impact:** Increases script flexibility, allowing it to run correctly even if the project folder is moved or the mount point changes.

### 3. run_salmon_quant.sh
* **The Change:** Integrated metadata mapping via parallel arrays.
* **Almokhtar's code:** `for SAMPLE in "${ALL_SAMPLES[@]}"`
* **Rahma's code:** `for i in "${!SAMPLES[@]}"; do NAME=${NAMES[$i]}`
* **The Impact:** Links technical SRR IDs to biological sample names ("KO" vs "Rescue") directly in the output logs for easier tracking.

### 4. run_deseq2.R
* **The Change:** Shifted from raw data import to serialized object loading.
* **Almokhtar's code:** `txi <- tximport(files, type="salmon", tx2gene=tx2gene)`
* **Rahma's code:** `txi <- readRDS("data/processed/genome_wide_txi.rds")`
* **The Impact:** Ensures the differential expression analysis uses pre-validated data and significantly reduces script runtime.

### 5. run_enrichment.R
* **The Change:** Implemented error handling for external server dependencies.
* **Almokhtar's code:** `kegg_up <- enrichKEGG(gene = up_entrez, ...)`
* **Rahma's code:** `kegg_up <- try(enrichKEGG(gene = up_entrez, ...), silent = TRUE)`
* **The Impact:** Prevents the entire enrichment pipeline from crashing if the KEGG servers are down or the internet connection is unstable.

## Part 3: Results Verification
A comparative analysis was performed between the outputs of **Almokhtar's original code** and **Rahma's reproduced code**. 

### Phase Comparison
* **Quantification:** Both versions achieved an identical average mapping rate of **92.69%** across all 6 samples.
* **Differential Expression:** Both versions identified exactly **617 significant genes** (488 upregulated, 129 downregulated) with identical top-ranked genes.
* **Biological Clustering:** PCA results remained consistent, with **PC1 accounting for 84% of variance**, showing perfect separation between KO and Rescue groups.
* **Pathway Enrichment:** Both versions identified the same top biological themes, specifically **Extracellular Matrix Organization** and **PI3K-Akt signaling**.

## Current Status
- Scripts organized in `scripts/Rahmas_script`.
- Salmon index built and validated.
- Data integrity verified for all 6 samples.
- **Note:** Analysis results remain identical between the first and second versions of the scripts; optimization was focused strictly on code robustness, path flexibility, and error handling.

---

## Phase 5: ML Dysfunction Score Analysis

### Method Summary
* **Algorithm:** Random Forest using Leave-One-Out Cross-Validation (LOOCV), $n=6$.
* **Feature Selection:** Top 100 genes by absolute log2 fold change (selected from 617 significant DEGs).
* **Confirmation:** Elastic Net independently confirmed classification performance.

### Key Findings
1.  **Classification Performance (ROC = 1.0):** Both individual and group analyses achieved perfect separation between Knockout (KO) and Rescue samples.
2.  **Dysfunction Score Calibration:**
    * **KO Samples:** 96.8 – 97.6 (High Dysfunction)
    * **Rescue Samples:** 0.8 – 2.6 (Low Dysfunction)
3.  **Biological Consistency (Feature Importance):**
    The model independently prioritized genes that align with previous enrichment results:
    * **ECM Dominance:** *TMEM63C* (#1), *IGFN1* (#5), and *FNDC7* (#8) were top predictors.
    * **Autoregulation:** *TARDBP* (rank 10) was identified as a top discriminating feature, confirming the model's ability to detect TDP-43's known 3'UTR binding autoregulation.
4.  **Cryptic Transcription:** The appearance of neuronal genes like *SYN1* (#2) and *GABRA1* (#9) in a HeLa cell line suggests the model captured the loss of TDP-43’s role in repressing cryptic neuronal programs.

---

## Phase 7: Robustness Analysis

### Objective
To verify if the primary biological conclusions—specifically the significance of the Extracellular Matrix (ECM) pathway—remain stable across varying Differential Expression (DE) significance thresholds.

### Threshold Combinations Tested
| Profile | padj Cutoff | log2FC Cutoff | Resulting Gene Count |
| :--- | :--- | :--- | :--- |
| **Baseline** | < 0.05 | > 1.0 | 617 |
| **Strict P** | < 0.01 | > 1.0 | 515 |
| **Strict FC** | < 0.05 | > 1.5 | 353 |

### Stability Results
* **Signature Persistence:** The ECM signature remained statistically significant across all tested thresholds.
* **Pathway Ranking:** While the specific rank of the ECM pathway shifted (Rank 2 in Baseline vs. Rank 10 in Strict FC), the biological signal remained persistent.
* **Conclusion:** The findings of this project are highly robust and not dependent on arbitrary thresholding, confirming that the identified biological signals are a true reflection of the experimental conditions.

---
# Phase 5 & 7: Development & Troubleshooting Log

## Overview
This log documents the technical hurdles encountered during the machine learning modeling (Phase 5) and the robustness analysis (Phase 7). It serves as a reference for maintaining a clean project structure and consistent workflow.

---

## 🛠 Error & Resolution Log

| Error / Challenge | Technical Reason | Corrective Action (Troubleshooting) |
| :--- | :--- | :--- |
| **"Fatal error: cannot open file... No such file or directory"** | **Working Directory Mismatch:** The terminal was inside the `07_robustness` folder, but the R script was looking for a `results/` folder relative to the project root. | Reset the terminal session to the project root (`/mnt/h/KAUST/tdp43-dysfunction-score`) and called the script using the full relative path. |
| **"Russian Doll" Nested Directories** | **Relative Path Confusion:** Running `mkdir -p tdp43-dysfunction-score/...` while already inside the project created a duplicate project folder structure inside the real directory. | Used `rm -rf` to purge the redundant nested folders and verified the cleanup using the `tree` command. |
| **"cannot open the connection" (write.csv error)** | **Path Over-specification:** The R script's `write.csv` path included the root folder name, causing R to look for a non-existent subdirectory. | Updated the `write.csv` line in `r_test_thresholds.R` to use proper relative paths starting from `scripts/`. |
| **Git: "Changes not staged" (Validation Noise)** | **Untracked Data Overhead:** Heavy validation generated large `.fastq.gz` and `.log` files that cluttered the `git status` output. | Implemented targeted staging using `git add scripts/Rahmas_scripts/07_robustness/` to isolate code and results from raw genomic data. |
| **Permission Denied** | **File Permissions:** New scripts created via `nano` or `touch` lack execution bits by default. | Applied `chmod +x` to the script or executed it explicitly via the `Rscript` command. |

---

## 🚀 Final Workflow Best Practices
Based on the challenges above, the following "Best Practice" workflow was established for all subsequent project phases:

1.  **Anchor at the Root:** Maintain the terminal session at the project root (`/mnt/h/KAUST/tdp43-dysfunction-score`) at all times.
2.  **Relative Pathing Strategy:** All R and Bash file paths must be written starting from `scripts/` or `data/`. Never include the project folder name (`tdp43-dysfunction-score`) in internal script paths.
3.  **Visual Validation:** Use the `tree` command regularly when creating new directories to prevent accidental nesting.
4.  **Selective Staging:** Avoid `git add .` to prevent pushing large genomic datasets. Use specific directory paths to keep the repository lean and efficient.

---
**Status:** All technical hurdles resolved.
