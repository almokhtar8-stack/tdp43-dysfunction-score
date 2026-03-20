# Reproducibility Guide: Genome-Wide TDP-43 Dysfunction Analysis

**Project:** TDP-43 Dysfunction Score - ML-Based Early Detection  
**Scope:** Complete Genome-Wide RNA-seq (Chr 1-22, X)  
**Author:** Rahma  
**Environment:** WSL2 (Ubuntu) on Microsoft Surface Pro  

---

## 1. Environment Setup

### 1.1 Hardware & Mounting
The complete genome analysis requires ~100GB of space. We utilize an external **H: Drive** to handle the 67GB of raw data and associated indices.

**Mounting the H: Drive with Linux permissions:**
```bash
sudo mkdir -p /mnt/h
sudo mount -t drvfs H: /mnt/h -o uid=$(id -u),gid=$(id -g),fmask=111,dmask=000
1.2 Software DependenciesAll tools must be managed via the genomics Conda environment to ensure version consistency across all 22 autosomes and the X chromosome.SRA Toolkit (3.2.1): Required for prefetch and fasterq-dump.Salmon (1.10.3): Required for salmon index and salmon quant.R (4.3.1): Required for DESeq2, tximport, GenomicFeatures, and clusterProfiler.Bashconda activate genomics
2. Pipeline Execution (Phase-by-Phase)Navigate to the project root: /mnt/h/KAUST/tdp43-dysfunction-score/. All reproduced scripts are executed from the scripts/Rahmas_scripts/ directory.Phase 0: Data & Reference SetupDownload Ensembl References: bash scripts/Rahmas_scripts/00_setup/r_download_ensembl.shAction: Downloads GRCh38 cDNA FASTA and GTF annotation from Ensembl Release 116.Create tx2gene Map: Rscript scripts/Rahmas_scripts/00_setup/r_create_tx2gene.RAction: Processes the GTF into an RDS mapping file for gene-level quantification.Download Raw Genome Data: bash scripts/Rahmas_scripts/00_setup/r_download_sra.shAction: Fetches and compresses 6 samples (SRR10045016 to SRR10045021).Phase 1: QuantificationBuild Salmon Index: bash scripts/Rahmas_scripts/02_quantification/r_build_salmon_index.shAction: Creates a genome-wide index using k-mer=31.Run Salmon Quantification: bash scripts/Rahmas_scripts/02_quantification/r_run_salmon.shAction: Estimates transcript abundance for all 6 samples.Phase 2: Statistical Analysis & VizDifferential Expression: Rscript scripts/Rahmas_scripts/03_differential_expression/r_run_deseq2.RAction: Identifies Significant DEGs genome-wide (padj < 0.05).Generate Figures: Rscript scripts/Rahmas_scripts/04_visualization/r_create_plots.RAction: Produces Volcano, PCA, MA, and Heatmap plots in results/figures/.Pathway Enrichment: Rscript scripts/Rahmas_scripts/06_enrichment_analysis/r_run_enrichment.RAction: Performs GO and KEGG enrichment analysis.3. Expected Benchmarks (Genome-Wide)TaskEstimated RuntimeData Size / CountSRA Data Download5h 10m67GB (Raw FASTQ)Salmon Indexing5m~500MB IndexSalmon Quantification2h 00m~20m per sampleImport & DESeq210m~78,000 GenesVisualization5m4 High-Res PNGsEnrichment Analysis15mGO & KEGG Tables4. Common Errors & Solutions4.1 "No such file" (Stale Mount)Issue: Terminal shows /mnt/h/ is empty or missing after system sleep.Solution: Reset the Windows-to-WSL bridge:Bashcd ~
sudo umount -l /mnt/h
# Re-run the mount command from Section 1.1
4.2 Gzip CorruptionIssue: unexpected end of file during FASTQ processing.Solution: Caused by network interruptions. Delete the corrupted sample and re-run:Bashrm -rf data/raw/SRRXXXXXXX*
bash scripts/Rahmas_scripts/00_setup/r_download_sra.sh
4.3 KEGG ConnectivityIssue: enrichKEGG hangs or returns a network error.Solution: Ensure internet is active. The script uses try() blocks to ensure GO Enrichment finishes even if the KEGG server is unreachable.4.4 WSL RAM ManagementIssue: Process is Killed due to high memory usage.Solution: Close high-memory Windows apps and run wsl --shutdown in PowerShell to clear the cache.Validation: Pipeline produced exactly 617 significant DEGs genome-wide.
### 3. Save, Exit, and Push
1.  **Save:** Press `Ctrl+O`, then `Enter`.
2.  **Exit:** Press `Ctrl+X`.
3.  **Push to GitHub:**
```bash
cd /mnt/h/KAUST/tdp43-dysfunction-score/
git add scripts/Rahmas_scripts/reproducibility_guide.md
git commit -m "docs: finalized genome-wide reproducibility guide"
git push origin main
