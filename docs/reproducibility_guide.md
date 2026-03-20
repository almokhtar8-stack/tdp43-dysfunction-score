**Project:** TDP-43 Dysfunction Score  
**Scope:** Complete Human Genome (Chr 1-22, X)  
**Author:** Rahma  
**Environment:** WSL2 (Ubuntu) on Microsoft Surface Pro  
**Data Source:** SRA Samples SRR10045016–SRR10045021  

---

## 1. Environment Setup & Infrastructure

### 1.1 Mounting the External Storage (H: Drive)
The raw data (~67GB) exceeds the standard WSL root VHDX size. I used an external drive mounted with metadata permissions to ensure Linux could manage the files correctly.

```bash
# Create mount point
sudo mkdir -p /mnt/h

# Mount H: drive with full user permissions
sudo mount -t drvfs H: /mnt/h -o uid=$(id -u),gid=$(id -g),fmask=111,dmask=000
```

### 1.2 Software Stack (Conda)
I used a dedicated environment named `genomics` to manage all bioinformatics dependencies.

* **SRA Toolkit (3.2.1):** Required for `prefetch` and `fasterq-dump`.
* **Salmon (1.10.3):** Required for `salmon index` and `salmon quant`.
* **R (4.3.1):** Required for `DESeq2`, `tximport`, `GenomicFeatures`, and `clusterProfiler` (Bioconductor 3.18).

```bash
conda activate genomics
```
## 2. Step-by-Step Pipeline Execution

### Phase 0: Data & Reference Preparation
* **Ensembl Download:** Ran `bash scripts/Rahmas_scripts/00_setup/r_download_ensembl.sh` to pull GRCh38 transcriptome and GTF.
* **Transcript-to-Gene Mapping:** Ran `Rscript scripts/Rahmas_scripts/00_setup/r_create_tx2gene.R`.
    * **Result:** Generated `tx2gene.rds` with 78,941 unique genes.
* **SRA Download & Processing:** Ran `bash scripts/Rahmas_scripts/00_setup/r_download_sra.sh`.
    * **Process:** `prefetch` -> `fasterq-dump` -> `gzip`.

### Phase 1: Quality Control (QC)
Before quantification, I performed a full quality assessment of the raw 12 FASTQ files (6 samples, paired-end) to ensure data integrity.

* **FastQC & MultiQC:** Ran `bash scripts/Rahmas_scripts/01_quality_control/r_run_qc.sh`.
    * **Action:** Generated per-base quality scores, adapter content reports, and duplication levels.
    * **Aggregation:** Used MultiQC to merge 12 individual FastQC reports into a single HTML summary.
    * **Result:** Confirmed high-quality reads across all samples (Green Phred scores > 30).

**How to run:**
```bash
bash scripts/Rahmas_scripts/01_quality_control/r_run_qc.sh
```

### Phase 2: Quantification
* **Salmon Indexing:** Ran `bash scripts/Rahmas_scripts/02_quantification/r_build_salmon_index.sh`.
* **Salmon Quant:** Ran `bash scripts/Rahmas_scripts/02_quantification/r_run_salmon.sh` with `--validateMappings`.

### Phase 3, 4, and 6: Statistical Analysis & Viz
* **DESeq2 Analysis:** Ran `Rscript scripts/Rahmas_scripts/03_differential_expression/r_run_deseq2.R`.
    * **Filter:** `rowSums >= 10`.
* **Visualization:** Ran `Rscript scripts/Rahmas_scripts/04_visualization/r_create_plots.R`.
* **Enrichment:** Ran `Rscript scripts/Rahmas_scripts/06_enrichment_analysis/r_run_enrichment.R`.

---

## 3. Benchmarks & Performance

| Task | Runtime | Hardware Stress |
| :--- | :--- | :--- |
| **SRA Data Download** | 5h 10m | High Network/Disk I/O |
| **Quality Control (QC)** | 45m | Moderate CPU / Multi-threading |
| **Salmon Indexing** | 5m | High CPU/RAM |
| **Salmon Quantification** | 2h 00m | Sustained CPU Load |
| **Import & DESeq2** | 10m | Moderate RAM |
| **Visualization** | 5m | 4 High-Res PNGs |
| **Enrichment Analysis** | 15m | Network (KEGG API) |
---

## 4. Troubleshooting & Solutions

* **Drive Mount Failure:** Use `sudo umount -l /mnt/h` and remount if the drive becomes stale after Windows sleep.
* **"Killed" Process:** If Salmon crashes, close high-memory Windows apps and run `wsl --shutdown` in PowerShell to clear the RAM cache.
* **Gzip Corruption:** Delete the specific sample folder in `data/raw/` and re-run the download script for that specific SRR.
* **KEGG API Errors:** The R script utilizes `try()` blocks to ensure GO Enrichment still completes even if the KEGG server is unreachable.

---

## 5. Final Validation Results

* **Total Significant DEGs:** 617
* **Upregulated:** 488 | **Downregulated:** 129
* **Conclusion:** Reproduction complete. The biological signal for TDP-43 dysfunction is consistent across the entire genome.

