# Technical Validation Report: Evaluation of Dataset GSE122649

## 1. Executive Summary
This report documents the validation of a computational pipeline designed to calculate TDP-43 dysfunction scores. While the pipeline was successfully established and technical hurdles within the WSL environment were resolved, the biological characteristics of the **GSE122649** dataset—specifically species mixing and extreme transcriptomic bias—rendered it unsuitable for validating a human-specific disease model.

---

## 2. Data Acquisition & Download Metrics
A total of **32 samples** were retrieved using the SRA Toolkit (`prefetch` and `fastq-dump`). The acquisition phase represented a significant time investment, characterized by a consistent **read length of 150bp (paired-end)** across samples.

**Sample 14 (SRR8263608)** was a massive outlier; due to its 32GB size and server-side constraints, the download process required **27 hours** to complete.

| Sample # | Sample ID | Total Reads | Read Length | Download Time (HH:MM:SS) |
| :--- | :--- | :--- | :--- | :--- |
| 1 | SRR8263595 | 1,491,378 | 150bp | 00:01:02 |
| 2 | SRR8263596 | 992,304 | 150bp | 00:00:12 |
| 3 | SRR8263597 | 826,084 | 150bp | 00:00:08 |
| 4 | SRR8263598 | 1,593,758 | 150bp | 00:00:17 |
| 5 | SRR8263599 | 1,588,738 | 150bp | 00:00:15 |
| 6 | SRR8263600 | 1,124,146 | 150bp | 00:00:09 |
| 7 | SRR8263601 | 1,204,882 | 150bp | 00:00:10 |
| 8 | SRR8263602 | 1,126,054 | 150bp | 00:00:11 |
| 9 | SRR8263603 | 1,409,580 | 150bp | 00:00:14 |
| 10 | SRR8263604 | 962,202 | 150bp | 00:00:09 |
| 11 | SRR8263605 | 103,658 | 150bp | 00:00:03 |
| 12 | SRR8263606 | 308,274 | 150bp | 00:00:05 |
| 13 | SRR8263607 | 204,584 | 150bp | 00:00:04 |
| 14 | **SRR8263608** | **677,182,122** | **150bp** | **27:00:00** |
| 15 | SRR8263609 | 298,542 | 150bp | 00:00:06 |
| 16 | SRR8263610 | 1,938,374 | 150bp | 00:01:00 |
| 17 | SRR8263611 | 114,432 | 150bp | 00:00:03 |
| 18 | SRR8263612 | 1,605,422 | 150bp | 00:00:30 |
| 19 | SRR8263613 | 281,506 | 150bp | 00:00:04 |
| 20 | SRR8263614 | 295,360 | 150bp | 00:00:05 |
| 21 | SRR8263615 | 295,320 | 150bp | 00:00:05 |
| 22 | SRR8263616 | 295,280 | 150bp | 00:00:05 |
| 23 | SRR8263617 | 1,220,102 | 150bp | 00:00:23 |
| 24 | SRR8263618 | 5,127,490 | 150bp | 00:01:21 |
| 25 | SRR8263619 | 884,242 | 150bp | 00:00:14 |
| 26 | SRR8263620 | 304,602 | 150bp | 00:00:05 |
| 27 | SRR8263621 | 1,481,222 | 150bp | 00:00:18 |
| 28 | SRR8263622 | 293,106 | 150bp | 00:00:05 |
| 29 | SRR8263623 | 299,210 | 150bp | 00:00:05 |
| 30 | SRR8263624 | 874,102 | 150bp | 00:00:15 |
| 31 | SRR8263625 | 160,150 | 150bp | 00:00:03 |
| 32 | SRR8263626 | 304,112 | 150bp | 00:00:05 |

---

## 3. Procedural Log & Task Duration
The technical execution phase took place on **April 8, 2026**. 

| Time | Step Taken | Description | Duration |
| :--- | :--- | :--- | :--- |
| 01:03 | Script Initialization | Created `run_salmon_validation.sh` for batch processing. | 1 min |
| 01:04 | Path Configuration | Updated paths to absolute `/mnt/h/...` for WSL/Windows compat. | 1 min |
| 01:05 | Salmon Quantification | Batch execution. Sample 11 (SRR8263605) completed in 100s. | 16 mins |
| 01:23 | Result Inspection | Audited mapping logs; verified 92.9% rate for Human samples. | 2 mins |
| 01:35 | Data Integrity Audit | Executed `grep` and `sort` on `quant.sf` output files. | 12 mins |
| 01:50 | Final Pivot Decision | Dataset rejected for biological validation. | 15 mins |

---

## 4. Challenges & Technical Solutions

### Species Mismatch
**Issue:** Samples SRR8263595–SRR8263604 returned a **0% mapping rate**.
**Discovery:** Technical investigation revealed these were **Mouse (Mus musculus)** sequences included in the same benchmarking series.
**Solution:** Isolated the human 600-series (e.g., SRR8263605) for human index validation.

### Environment & Permissions
**Issue:** `-bash: Permission denied` and inability to locate FastQ files.
**Solution:** Utilized `chmod +x` and transitioned to **absolute paths** to bridge the WSL-Windows drive mount file system.

### Library Strandedness
**Issue:** Initial low mapping due to manual library type misconfiguration.
**Solution:** Employed Salmon’s **`-l A` (Automatic Detection)** flag. This allowed the software to determine the library format dynamically, resulting in >90% mapping.

---

## 5. Justification for Dataset Pivot
While the quantification pipeline is technically operational, GSE122649 is biologically unsuitable for TDP-43 scoring:

1. **Extreme Transcriptomic Bias:** A single mitochondrial rRNA transcript (`ENST00000407218.6`) accounted for **99.99%** of all mapped reads.
2. **Signal Attenuation:** The overwhelming presence of rRNA "crowded out" protein-coding transcripts, resulting in TPM values of 0.00 for target genes.
3. **Requirement for Complexity:** Validating a dysfunction score requires a diverse transcriptome capable of showing subtle splicing and expression changes.

**Conclusion:** The project will move to an alternative dataset that provides the diverse human gene expression necessary for accurate biological validation.
