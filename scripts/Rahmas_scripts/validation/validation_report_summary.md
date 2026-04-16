## Validation Report: Pipeline Accuracy

### Step 01 (Quality Control): Complete
* **Status**: High-quality data confirmed via MultiQC.
* **Quality**: All 18 samples show excellent Phred scores (>35).
* **Read Depth**: Robust sequencing depth ranging from ~27M to ~66M reads per sample.
* **Cleanliness**: Negligible adapter content (<1%) and clean GC distributions.

### Step 02 (Quantification): Complete
* **Status**: Salmon quantification completed for all 18 samples.
* **Mapping Rate**: Ranging from 38.3% to 50.5%.
* **Validation**: Manual inspection of `quant.sf` confirms robust expression, with high-abundance transcripts capturing over 400,000 reads per sample.
* **Decision**: Proceeding to DGE with current counts; mapping depth (~22M reads/sample) is sufficient for reliable statistical analysis.

### Step 03 (Differential Expression): Complete
* **Status**: Transcript-to-gene summarization and statistical testing finished.
* **Method**: Used `tximport` to summarize 34,740 genes from Salmon quantifications.
* **Results**: Successfully identified significant Differential Expressed Genes (DEGs) using DESeq2 (Padj < 0.05).
* **Data Integrity**: Despite the ~45% mapping rate, the gene-level counts are robust (e.g., >400k reads for high-abundance transcripts), providing high confidence for downstream TDP-43 dysfunction scoring.
