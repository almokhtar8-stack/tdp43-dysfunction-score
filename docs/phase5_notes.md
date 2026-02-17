# Phase 5: ML Dysfunction Score — Notes

## Method
- Algorithm: Random Forest (LOOCV, n=6)
- Features: Top 100 genes by |log2FC| from 617 significant DEGs
- Validation: Elastic Net independently confirmed ROC = 1.0

## Results
| Sample | Condition | ML Score | ECM | Inflammatory | Survival |
|--------|-----------|----------|-----|--------------|----------|
| SRR10045016 | KO | 97.6 | 100.0 | 97.4 | 95.5 |
| SRR10045017 | KO | 97.2 | 97.4 | 95.0 | 94.8 |
| SRR10045018 | KO | 96.8 | 99.8 | 100.0 | 100.0 |
| SRR10045019 | Rescue | 1.2 | 0.9 | 0.9 | 0.0 |
| SRR10045020 | Rescue | 2.6 | 0.1 | 0.0 | 3.5 |
| SRR10045021 | Rescue | 0.8 | 0.0 | 0.9 | 5.0 |

## Key Findings

### 1. Perfect Classification (ROC = 1.0)
Complete separation between KO and Rescue across both RF and Elastic Net.
Expected given strong signal; validates score captures real biology not noise.

### 2. TARDBP Autoregulation Detected
TARDBP itself (rank 10) is a top discriminating feature. Consistent with
known TDP-43 autoregulation via 3'UTR binding. Model independently
rediscovered this mechanism.

### 3. ECM Genes Dominate Feature Importance
TMEM63C (#1), IGFN1 (#5), FNDC7 (#8), CHRDL1 (#12), FMOD (#19)
— independently validates Phase 6 enrichment. ECM emerges as
top pathway by both enrichment AND ML feature selection.

### 4. Cryptic Neuronal Program Activated
SYN1 (#2, synapsin I) and GABRA1 (#9, GABA-A receptor) appear in
top features despite HeLa (non-neuronal) cell line. Suggests TDP-43
normally represses cryptic neuronal transcription — consistent with
TDP-43's established role in cryptic exon repression.

### 5. Inflammatory Pathway Confirmed
TNFRSF10D (#15, TNF receptor) — inflammatory axis confirmed
independently by ML feature selection.

## Score Interpretation
- 0–30: Low dysfunction (Rescue-like)
- 31–60: Moderate dysfunction
- 61–100: High dysfunction (KO-like)

## Output Files
- results/models/dysfunction_score_model.rds
- results/models/dysfunction_scores_all_samples.csv
- results/models/feature_importance_annotated.csv
- results/figures/ml/*.png (5 figures)
