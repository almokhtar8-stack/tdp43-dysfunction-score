# Phase 3: Differential Expression Analysis

## Date: Feb 14, 2026

## Script: scripts/03_differential_expression/run_deseq2.R

---

## Summary

**Comparison:** TDP-43 KO vs Rescue (Rescue as reference)

**Status:** ✅ COMPLETE

**Total runtime:** ~10 minutes

---

## Results Overview

| Metric | Value |
|--------|-------|
| Total genes analyzed | 16,536 |
| Significant genes (padj < 0.05, \|log2FC\| > 1) | 617 (3.73%) |
| Upregulated in KO | 488 (79% of significant) |
| Downregulated in KO | 129 (21% of significant) |

---

## Analysis Steps

1. **Load tx2gene mapping:** 646,577 transcripts → genes
2. **Import Salmon counts:** tximport from 6 samples
3. **Create DESeq2 dataset:** 34,740 genes initially
4. **Pre-filter:** Retained 16,536 genes (≥10 reads)
5. **Run DESeq2:** Estimate size factors, dispersions, fit models
6. **Extract results:** KO vs Rescue comparison
7. **Filter significant:** padj < 0.05, |log2FC| > 1

---

## Key Findings

### Biological Interpretation
- **Majority upregulated in KO (79%)** suggests TDP-43 primarily acts as a repressor
- Loss of TDP-43 → loss of repression → gene upregulation
- Consistent with known TDP-43 biology ✅

### Top Differentially Expressed Genes

| Gene ID | log2FC | padj | Direction |
|---------|--------|------|-----------|
| ENSG00000067057 | -4.03 | 0 | Down in KO |
| ENSG00000095319 | -2.29 | 0 | Down in KO |
| ENSG00000113140 | +3.25 | 0 | Up in KO |
| ENSG00000116299 | +4.45 | 0 | Up in KO |
| ENSG00000120948 | -3.79 | 0 | Down in KO |

---

## Output Files

### Tables (results/tables/)
- `deseq2_results_all.csv` - All 16,536 genes with stats
- `deseq2_results_significant.csv` - 617 significant genes
- `genes_upregulated_in_KO.csv` - 488 upregulated genes
- `genes_downregulated_in_KO.csv` - 129 downregulated genes
- `deseq2_summary_stats.csv` - Summary statistics

### Models (results/models/)
- `dds.rds` - DESeq2 object (for downstream analysis)

---

## Quality Metrics

- ✅ Low count filtering: Removed 18,204 genes with <10 reads
- ✅ Outliers: Only 5 genes (0.03%)
- ✅ Independent filtering: 2,565 genes (16%)
- ✅ Extremely significant p-values (top genes p ≈ 0)
- ✅ Strong effect sizes (log2FC up to ±4.5)

---

## Next Steps

**Phase 4:** Visualization
- PCA plot
- Volcano plot
- MA plot
- Heatmap of top genes
- Gene expression boxplots
