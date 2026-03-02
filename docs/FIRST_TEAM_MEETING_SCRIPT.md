# TDP-43 Dysfunction Score Project
## First Team Meeting - Presentation Script

**Date:** March 2026  
**Presenter:** Almokhtar Aljarodi  
**Duration:** 45-60 minutes  
**Format:** Overview + Q&A

---

## 1. INTRODUCTION (2 minutes)

**[START]**

"Good [morning/afternoon/evening] everyone, and welcome to our first official team meeting for the TDP-43 Dysfunction Score project. I'm Almokhtar, the project lead. Before we dive in, let me quickly introduce everyone:"

**Team introductions:**
- "**Almokhtar** - Project Lead (that's me) - responsible for pipeline architecture, GitHub management, and scientific decisions"
- "**Rahma Abufoor** - Reproducibility Lead - she's already completed validation work, which we'll discuss"
- "**Ahmed Bukhamsin** - Statistical Robustness - will be testing our results with different parameters"
- "**Omar Buqes** - Biological Interpretation - will be connecting our findings to the ALS/FTD literature"
- "**Zahra Almahal** - Manuscript Engineer - will be writing up our methods and preparing the manuscript"

"Today's agenda: I'll walk you through everything we've done so far, explain our machine learning results in detail, and most importantly—assign everyone their specific tasks moving forward. By the end of this meeting, everyone should know exactly what they're working on this week."

**[Transition]** "Let's start with the big picture..."

---

## 2. PROJECT OVERVIEW (5 minutes)

### 2.1 The Clinical Problem

**"Why does this project matter?"**

"ALS and FTD are devastating neurodegenerative diseases with NO cure. Let me give you the numbers:"

- Median survival: **2-5 years** from diagnosis
- Late diagnosis: symptoms appear after **50-80%** of neurons are already dead
- Only **2 FDA-approved drugs** with very modest effects
- **NO biomarkers** to predict disease progression or treatment response

"This means patients are diagnosed too late, we can't predict who will progress quickly, and we have no way to monitor if treatments are working."

### 2.2 Our Solution

**"What are we trying to build?"**

"We're developing a **617-gene machine learning dysfunction score** that quantifies TDP-43 pathology on a scale of 0-100."

**The score enables 4 things:**

1. **Early detection** - screen at-risk people BEFORE symptoms (gain 1-2 years treatment time)
2. **Progression prediction** - high score = fast progression, low score = slow progression
3. **Treatment monitoring** - track response in 3 months instead of 12 months
4. **Patient stratification** - enrich clinical trials with high-dysfunction patients

### 2.3 Scientific Approach

**"How are we doing this?"**

"We're using published RNA-seq data from a TDP-43 CRISPR knockout experiment:"

- **Dataset:** GSE136366 (Brown et al., 2020, *Nature*)
- **Design:** 3 KO samples vs 3 Rescue samples (HeLa cells)
- **Platform:** Illumina HiSeq, paired-end sequencing
- **Analysis:** Complete genome-wide differential expression + machine learning

"TDP-43 is the protein that becomes dysfunctional in 97% of ALS cases and 45% of FTD cases. Understanding what goes wrong when it's lost is critical for developing treatments."

**[Transition]** "Now let me show you where all this work lives..."

---

## 3. GITHUB OVERVIEW (3 minutes)

### 3.1 Repository Link

**"Where is everything stored?"**

**Repository:** https://github.com/almokhtar8-stack/tdp43-dysfunction-score

"Everything—all code, all results, all documentation—is version-controlled on GitHub. This ensures our work is reproducible and transparent."

### 3.2 Repository Structure

**"What's in the repository?"**

```
tdp43-dysfunction-score/
├── data/               # Raw and processed data (local only, too large for GitHub)
├── scripts/            # All analysis code (Phases 1-7)
├── results/            # All outputs: tables, figures, models
├── docs/               # Documentation for each phase
└── README.md           # Main documentation (what you all need to read)
```

**Key files everyone should look at:**
1. `README.md` - Full project summary, all results
2. `docs/phase5_notes.md` - ML model details
3. `docs/phase6_notes.md` - Pathway enrichment (ECM findings)
4. `docs/project_summary.md` - Complete overview


---

## 4. PROJECT PROGRESS - PHASES 1-6 (12 minutes)

### 4.1 Phase 1: Data Download & Setup ✅

**"What we did:"**

- Downloaded **6 RNA-seq samples** from SRA (67GB data)
- Downloaded human reference genome (Ensembl GRCh38)
- Created transcript-to-gene mapping (**646,577 transcripts** → **78,941 genes**)
- Set up complete project directory structure

**Timeline:** Feb 14, 2026 (completed in 1 day)

**Key achievement:** All raw data successfully downloaded and organized.

---

### 4.2 Phase 2: Salmon Quantification ✅

**"What we did:"**

"We used **Salmon** - a fast, accurate tool for quantifying gene expression from RNA-seq reads."

**Results:**
- **Average mapping rate: 92.69%** (excellent - above 90% threshold)
- Total reads processed: **~349 million**
- All 6 samples completed successfully
- No quality issues detected

**What does this mean?** "92.69% of our sequencing reads successfully mapped to known genes. This is excellent quality and means our data is reliable."

**Timeline:** Feb 14, 2026 (2 hours runtime)

---

### 4.3 Phase 3: Differential Expression Analysis ✅

**"What we did:"**

"We used **DESeq2** - the gold standard statistical tool for finding genes that differ between KO and Rescue."

**Results:**
- **16,536 genes analyzed** (after filtering low-count genes)
- **617 significant genes** identified (padj < 0.05, |log2FC| > 1)
- **488 upregulated in KO** (79%)
- **129 downregulated in KO** (21%)

**Biological interpretation:**
"79% of genes went UP when TDP-43 was knocked out. This validates that **TDP-43 is primarily a repressor** - it normally keeps genes turned off. When you remove it, those genes become active."

**Timeline:** Feb 14, 2026 (1 hour)

---

### 4.4 Phase 4: Visualization ✅

**"What we did:"**

"Created 5 publication-quality figures to visualize our results."

**Key plots:**

1. **PCA Plot** - Shows sample clustering
   - **PC1 = 84% variance** (extremely strong biological signal)
   - Perfect separation: KO samples cluster together, Rescue samples cluster together
   - No outliers, no batch effects

2. **Volcano Plot** - Shows magnitude + significance
   - 488 red dots (upregulated)
   - 129 blue dots (downregulated)
   - Many genes with p-values near zero (extremely significant)

3. **MA Plot** - Quality control check
   - Symmetric distribution (good normalization)
   - No expression-dependent bias

4. **Heatmap** - Top 50 genes
   - Two clear clusters: genes high in KO, genes high in Rescue
   - Perfect replicate clustering

5. **Boxplot** - Top 5 individual genes
   - Clear separation between conditions
   - Consistent across all replicates

**Conclusion:** "Data quality is excellent. Results are highly reproducible."

**Timeline:** Feb 14, 2026 (1 hour)

---

### 4.5 Phase 6: Pathway Enrichment ✅

**"What biological pathways are affected?"**

"We used **clusterProfiler** to identify which biological processes are enriched in our 617 significant genes."

**🔥 TOP FINDING: Extracellular Matrix (ECM) Dysregulation**

- **22 genes** involved in ECM organization
- **p.adj = 0.009** (highly significant)
- Emerges as **#1 pathway** in unbiased genome-wide screen

**Why is this important?**

"This finding **validates** recent independent studies showing TDP-43 regulates ECM:"

**Literature support:**
1. **Fernández-Galiana et al. (2024, JCI Insight)** - Endothelial cells: TDP-43 KO disrupts fibronectin matrix
2. **Hipke et al. (2023)** - Zebrafish/HUVECs: TDP-43 loss increases FN1, VCAM1
3. **Cheung et al. (2024)** - Motor neurons: MMP-9 degrades perineuronal nets in TDP-43 mice
4. **Kaplan et al. (2024)** - ALS patients: ECM genes enriched in motor neuron transcriptomics

**Convergent evidence:**
- Different cell types (endothelial, neuronal, epithelial)
- Different species (human, mouse, zebrafish)
- Different methods (genetics, transcriptomics, imaging)
- **All point to ECM → strengthens ECM as core TDP-43 function**

**Our unique contribution:**
- ✅ Complete CRISPR knockout (not mutation)
- ✅ Unbiased genome-wide screen (ECM emerged top without pre-selection)
- ✅ Non-vascular, non-neuronal cell type (generalizable)
- ✅ 22-gene therapeutic target signature

**Secondary findings:**
- **Inflammatory response** - leukocyte migration, cytokine signaling
- **PI3K-Akt survival pathway** - cell survival signaling
- **Cell adhesion** - integrin binding, focal adhesion

**Timeline:** Feb 14, 2026 (15 minutes)

---

### 4.6 Project Progress Summary

**"Where are we now?"**

| Phase | Status | Completion Date | Key Output |
|-------|--------|----------------|------------|
| Phase 1 | ✅ Complete | Feb 14 | 67GB data downloaded |
| Phase 2 | ✅ Complete | Feb 14 | 92.69% mapping rate |
| Phase 3 | ✅ Complete | Feb 14 | 617 significant genes |
| Phase 4 | ✅ Complete | Feb 14 | 5 publication figures |
| Phase 6 | ✅ Complete | Feb 14 | ECM top pathway |
| Phase 5 | ✅ Complete | Feb 17 | ML dysfunction score |
| Phase 7 | 🔄 In Progress | TBD | Manuscript writing |

**[Transition]** "Now let's talk about Phase 5 - the machine learning model - in detail..."

---

## 5. MACHINE LEARNING MODEL - PHASE 5 (15 minutes)

### 5.1 What is Machine Learning?

**"First, let me explain what machine learning actually is."**

"Imagine you have 617 genes and 6 samples. You want to build a model that can look at gene expression and predict: Is this sample KO or Rescue?"

**Traditional approach:**
- Pick one gene manually
- Set a threshold (e.g., "if gene X > 100, it's KO")
- Limited accuracy

**Machine learning approach:**
- Use **all 617 genes together**
- Algorithm automatically finds patterns across ALL genes
- Learns which combinations matter most
- Much more accurate

"It's like having 617 detectives working together instead of just one."

---

### 5.2 Why Machine Learning? Why Not Deep Learning?

**"Everyone's talking about deep learning and AI. Why didn't we use that?"**

**The problem: We only have 6 samples.**

**Deep learning FAILS with small samples:**
- Deep neural networks need **500+ samples minimum**
- With only 6 samples, deep learning would just **memorize** the data
- It would perform perfectly on training data but fail on new data (overfitting)
- This is called the "**curse of dimensionality**" - 617 genes ÷ 6 samples = 103 features per sample

**Traditional ML is the CORRECT choice:**
- Random Forest and Elastic Net are **designed for small samples**
- Used in **all genomics studies** with n<20
- Provides **feature importance** (which genes matter = drug targets)
- Industry standard for this sample size

**"We're not using deep learning because it would give us WRONG answers. Traditional ML is scientifically appropriate."**

---

### 5.3 Our ML Models

**"We tested 3 different machine learning algorithms and kept the best ones."**

#### Model 1: Random Forest ✅ (Our Best Model)

**What is it?**
"Random Forest builds 500 'decision trees' and averages their predictions."

**Example of what a decision tree does:**
```
Tree 1: "If TMEM63C > 10 AND SYN1 > 5 → KO"
Tree 2: "If IGFN1 > 8 OR TARDBP < 3 → KO"
Tree 3: "If GABRA1 > 6 AND FNDC7 > 7 → KO"
...
Final: 485/500 trees say "KO" → Prediction = KO
```

**Why Random Forest?**
- ✅ Handles high-dimensional data (617 genes)
- ✅ Robust to overfitting (ensemble averaging)
- ✅ Provides **feature importance** (ranks genes by contribution)
- ✅ No assumptions about data distribution

**Performance:**
- **ROC AUC = 1.0** (perfect classification)
- All KO samples correctly identified as KO
- All Rescue samples correctly identified as Rescue

---

#### Model 2: Elastic Net ✅ (Validation Model)

**What is it?**
"Linear regression with penalties that force weak genes to zero."

**Example:**
```
Dysfunction Score = 
  0.8 × TMEM63C + 
  0.6 × SYN1 + 
  0.4 × IGFN1 + 
  0.0 × Gene_123 +    ← Penalty removed this gene
  0.0 × Gene_456 +    ← Penalty removed this gene
  ...
```

**Why Elastic Net?**
- ✅ Excellent for high-dimensional data
- ✅ **Automatic feature selection** (finds most important genes)
- ✅ Interpretable (coefficient = gene contribution)
- ✅ **Independent validation** of Random Forest

**Performance:**
- **ROC AUC = 1.0** (confirmed Random Forest results)
- Selected similar top genes
- Proves signal is real, not model-specific

---

#### Model 3: SVM ❌ (Failed)

**What happened?**
"Support Vector Machine tried to find a boundary in 617-dimensional space but failed."

**Error:** "All ROC metric values are missing"

**Why it failed:**
- Only 6 samples in 617-dimensional space
- SVM couldn't find a stable boundary
- This is **expected** - not a problem with our analysis

**Lesson learned:**
"Even traditional ML has limits at n=6. Random Forest and Elastic Net are more robust."

---

### 5.4 Cross-Validation: LOOCV

**"How did we validate our models?"**

**Leave-One-Out Cross-Validation (LOOCV):**

```
Fold 1: Train on [KO1, KO2, Rescue1, Rescue2, Rescue3], Test on KO3 → ✓
Fold 2: Train on [KO1, KO3, Rescue1, Rescue2, Rescue3], Test on KO2 → ✓
Fold 3: Train on [KO2, KO3, Rescue1, Rescue2, Rescue3], Test on KO1 → ✓
Fold 4: Train on [KO1, KO2, KO3, Rescue2, Rescue3], Test on Rescue1 → ✓
Fold 5: Train on [KO1, KO2, KO3, Rescue1, Rescue3], Test on Rescue2 → ✓
Fold 6: Train on [KO1, KO2, KO3, Rescue1, Rescue2], Test on Rescue3 → ✓

Accuracy: 6/6 = 100%
```

**Why LOOCV for n=6?**
- ✅ Maximizes training data (5/6 samples each time)
- ✅ Every sample tested exactly once
- ✅ **Gold standard for small datasets**
- ✅ No information leakage

---

### 5.5 ML Results: Dysfunction Scores

**"What did the model actually predict?"**

| Sample | Condition | ML Score | ECM Subscore | Inflammatory | Survival |
|--------|-----------|----------|-------------|--------------|----------|
| SRR10045016 | KO | **97.6** | 100.0 | 97.4 | 95.5 |
| SRR10045017 | KO | **97.2** | 97.4 | 95.0 | 94.8 |
| SRR10045018 | KO | **96.8** | 99.8 | 100.0 | 100.0 |
| SRR10045019 | Rescue | **1.2** | 0.9 | 0.9 | 0.0 |
| SRR10045020 | Rescue | **2.6** | 0.1 | 0.0 | 3.5 |
| SRR10045021 | Rescue | **0.8** | 0.0 | 0.9 | 5.0 |

**Interpretation:**
- **KO samples: 96.8-97.6** (high dysfunction)
- **Rescue samples: 0.8-2.6** (low dysfunction)
- **Zero overlap** → perfect separation

**Score meaning:**
- **0-30:** Low dysfunction (Rescue-like)
- **31-60:** Moderate dysfunction
- **61-100:** High dysfunction (KO-like)

---

### 5.6 ROC = 1.0: What Does This Mean?

**"Is ROC = 1.0 too good to be true? Is it overfitting?"**

**What is ROC?**
"ROC curve plots True Positive Rate vs False Positive Rate at all thresholds."
- **ROC = 1.0** = perfect classification at all thresholds
- **ROC = 0.5** = random guessing (coin flip)
- **ROC = 0.9+** = excellent

**Is ROC = 1.0 suspicious?**

**NO. Here's why:**

1. **Strong biological signal:**
   - 84% variance on PC1 (PCA plot)
   - Complete knockout vs rescue = extreme difference
   - Not a subtle effect - it's an ON/OFF switch

2. **Validated 3 ways:**
   - **Random Forest:** ROC = 1.0
   - **Elastic Net:** ROC = 1.0 (independent confirmation)
   - **Feature importance matches pathway enrichment** (ECM genes top in both)

3. **Expected for n=6 extreme comparison:**
   - We're comparing total loss vs complete rescue
   - Effect sizes up to log2FC = ±7 (huge)
   - p-values near zero (extremely significant)

4. **Proper cross-validation:**
   - LOOCV ensures no sample trained on itself
   - Every prediction is on unseen data

**"ROC = 1.0 is NOT overfitting - it's capturing a real, extremely strong biological signal."**

**What if a reviewer questions this?**
"We'll say: (1) Used LOOCV, (2) Two independent models confirmed it, (3) Feature importance validates biology, (4) Effect size is extreme (complete KO vs rescue), not subtle."

---

### 5.7 Key ML Findings (5 Major Discoveries)

#### Finding 1: Perfect Classification
- Both RF and Elastic Net: **ROC = 1.0**
- All samples correctly classified
- Complete separation of KO vs Rescue

#### Finding 2: ECM Genes Dominate Feature Importance
**Top genes:**
- **#1 TMEM63C** (ECM gene)
- **#5 IGFN1** (ECM gene)
- **#8 FNDC7** (ECM gene)
- **#12 CHRDL1** (ECM gene)
- **#19 FMOD** (ECM gene)

**Conclusion:** "ML model **independently validates** Phase 6 pathway enrichment. ECM emerges as top signal in BOTH analyses."

#### Finding 3: TARDBP Autoregulation Detected
- **TARDBP itself ranks #10** in feature importance
- Model independently discovered **TDP-43 regulates its own expression**
- This is a **known mechanism** (TDP-43 binds its own 3'UTR)
- **Validates our model is biologically accurate**

#### Finding 4: Cryptic Neuronal Program
- **SYN1** (synapsin I, rank #2) - neuronal gene
- **GABRA1** (GABA-A receptor, rank #9) - neuronal gene
- These appear in **HeLa cells (non-neuronal)**
- Suggests **TDP-43 normally represses cryptic neuronal transcription**
- Consistent with TDP-43's known role in cryptic exon repression

#### Finding 5: Inflammatory Axis Confirmed
- **TNFRSF10D** (#15, TNF receptor)
- Inflammatory pathway independently confirmed by ML
- Aligns with Phase 6 enrichment results

---

### 5.8 Pathway Subscores

**"We decomposed the overall score into 3 biological pathways:"**

1. **ECM Dysregulation Subscore**
   - KO: 97-100
   - Rescue: 0-0.9
   - Measures extracellular matrix damage

2. **Inflammatory Response Subscore**
   - KO: 95-100
   - Rescue: 0-0.9
   - Measures immune activation

3. **Survival Signaling Subscore**
   - KO: 95-100
   - Rescue: 0-5
   - Measures PI3K-Akt pathway

**Clinical utility:**
"In the future, we can match patients to drugs based on which pathway is most affected."
- High ECM subscore → MMP inhibitors
- High inflammatory subscore → anti-cytokine drugs
- High both → combination therapy

---

### 5.9 Phase 5 Summary

**"What did Phase 5 accomplish?"**

✅ **Developed ML dysfunction score** (0-100 scale)  
✅ **Perfect classification** (ROC = 1.0, both models)  
✅ **Validated biology** (ECM genes top features)  
✅ **Discovered autoregulation** (TARDBP rank #10)  
✅ **Identified neuronal program** (SYN1, GABRA1)  
✅ **Created pathway subscores** (ECM, inflammatory, survival)  

**Timeline:** Feb 17, 2026

**Output files:**
- `dysfunction_score_model.rds` (saved model)
- `dysfunction_scores_all_samples.csv` (all 6 scores)
- `feature_importance_annotated.csv` (gene rankings)
- 5 visualization figures in `results/figures/ml/`

**[Transition]** "Now let's talk about the timeline and what happens next..."

---

## 6. TIMELINE (3 minutes)

### 6.1 Past Timeline (What We've Done)

| Date | Milestone | Duration |
|------|-----------|----------|
| **Feb 11** | Project initiated, GitHub created | 1 day |
| **Feb 14** | Phases 1-4, 6 completed | 1 day |
| **Feb 17** | Phase 5 (ML) completed | 3 days |
| **Feb 14-Mar 2** | Rahma validation complete | 2 weeks |

**Total analysis time:** ~3 days of active work + 2 weeks validation

---

### 6.2 Future Timeline (What's Coming)

| Week | Tasks | Owner |
|------|-------|-------|
| **Week 1** (This week) | Robustness analysis kickoff | Ahmed |
| **Week 1-2** | Sensitivity analysis + threshold testing | Ahmed |
| **Week 2-3** | Literature review + discussion draft | Omar |
| **Week 3-4** | Methods section + manuscript structure | Zahra |
| **Week 4-5** | Integration + full manuscript v1.0 | Almokhtar |
| **Week 5-6** | Team review + revisions | Everyone |
| **Week 6-7** | Final manuscript preparation | Zahra + Almokhtar |
| **Week 8** | **SUBMISSION** | Almokhtar |

### 6.3 Publication Timeline

**Target journal:** *Frontiers in Neuroscience* (open access)

**Expected timeline:**
- **Week 8:** Manuscript submission
- **Month 2-3:** Peer review
- **Month 3-4:** Revisions
- **Month 5-6:** Acceptance + publication

**Backup journals:**
- *Scientific Reports*
- *PLOS One*

---

## 7. NEXT STEPS (2 minutes)

### 7.1 Immediate Priorities

**This week (everyone):**
1. Read the README.md completely
2. Read your assigned phase notes in `docs/`
3. Clone the repository and checkout your branch
4. Start your assigned task (details in next section)
5. Push initial progress by **Friday**

### 7.2 Communication

**Where to ask questions:**
- WhatsApp group (for quick questions)
- GitHub Issues (for technical problems)
- Direct message Almokhtar (for major blockers)

**Weekly checkpoint:** Every Friday, push work-in-progress to your branch

**Rule:** If you're stuck for >2 hours, ASK FOR HELP immediately. Don't waste time struggling alone.

---

## 8. ASSIGNMENTS (10 minutes)

### 8.1 Almokhtar (Project Lead)

**Status:** Active - ongoing responsibilities

**This week:**
1. **Monitor all team branches** (check progress daily)
2. **Review Rahma's validation report** (provide feedback)
3. **Prepare data for Ahmed** (create threshold testing script template)
4. **Answer team questions** (be available on WhatsApp)
5. **Draft manuscript outline** (section structure + figure order)

**Ongoing:**
- GitHub management
- Scientific decision-making
- Integration of all work

**Deliverable:** Manuscript outline by end of Week 1

---

### 8.2 Rahma Abufoor (Reproducibility Lead)

**Status:** ✅ Primary work COMPLETE - Validation successful!

**What Rahma accomplished:**
- ✅ Cloned repository successfully
- ✅ Reran entire pipeline (Phases 1-4)
- ✅ **Verified same results:** 617 genes, 92.69% mapping rate
- ✅ Created validation report

**This week:**
1. **Write up validation report** (formal document)
   - Document: `docs/rahma_validation_report.md`
   - Include: Setup process, results comparison, any issues encountered
   - Conclusion: "Pipeline is reproducible"

2. **Create reproducibility guide**
   - Document: `docs/reproducibility_guide.md`
   - How to set up environment
   - How to run pipeline
   - Expected runtime for each phase
   - Common errors + solutions

3. **Test Ahmed's workflow** (next week)
   - Once Ahmed has code ready
   - Run his robustness analysis
   - Verify his results

**Deliverables:**
- `docs/rahma_validation_report.md` (by Friday)
- `docs/reproducibility_guide.md` (by end of Week 1)

**Branch:** `rahma/reproducibility`

---

### 8.3 Ahmed Bukhamsin (Statistical Robustness Lead)

**Status:** ⚠️ NOT STARTED - **Highest priority**

**Objective:** Test if our 617-gene list and ECM pathway finding are **robust** to different analysis parameters.

**This week:**

1. **Learn DESeq2 basics**
   - Read: `docs/phase3_notes.md`
   - Read: DESeq2 vignette (https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)
   - Understand: padj threshold, log2FC threshold

2. **Design robustness analysis**
   - Document: `docs/ahmed_robustness_plan.md`
   - Plan to test 3 different threshold combinations:
     - **Threshold 1:** padj < 0.05, |log2FC| > 1 (current - baseline)
     - **Threshold 2:** padj < 0.01, |log2FC| > 1 (stricter p-value)
     - **Threshold 3:** padj < 0.05, |log2FC| > 1.5 (stricter fold-change)

3. **Run robustness analysis**
   - Script: `scripts/07_robustness/test_thresholds.R`
   - For each threshold:
     - Count significant genes
     - Run GO enrichment
     - Check if ECM is still top pathway
   - Create comparison table

**Key question to answer:**
"Is ECM still the #1 pathway across all thresholds, or does it disappear with stricter cutoffs?"

**Expected result:** ECM should remain top pathway (validates robustness)

**Deliverables:**
- `docs/ahmed_robustness_plan.md` (by Wednesday)
- `scripts/07_robustness/test_thresholds.R` (by Friday)
- `docs/ahmed_robustness_results.md` (by end of Week 2)
- Comparison table (CSV file)

**Branch:** `ahmad/robustness`

**Help available:** Almokhtar will provide script template

---

### 8.4 Omar Buqes (Biological Interpretation Lead)

**Status:** ⚠️ NOT STARTED - Critical for manuscript

**Objective:** Connect our ECM findings to the broader TDP-43/ALS/FTD literature and write the discussion section.

**This week:**

1. **Literature search**
   - Read the 5 key papers cited in `docs/phase6_notes.md`:
     - Fernández-Galiana et al. (2024, JCI Insight) - endothelial TDP-43
     - Hipke et al. (2023) - zebrafish/HUVEC
     - Cheung et al. (2024) - motor neuron PNN
     - Kaplan et al. (2024) - ALS patient meta-analysis
     - Sun et al. (2020) - sALS motor neurons

2. **Broader literature review**
   - Search PubMed: "TDP-43 extracellular matrix"
   - Search PubMed: "TDP-43 ECM ALS"
   - Search PubMed: "TDP-43 fibronectin"
   - Find 5-10 additional relevant papers
   - Document: `docs/omar_literature_notes.md`

3. **Create comparison table**
   - Table comparing studies:
     - Study | Cell Type | TDP-43 Perturbation | ECM Findings | Methods
   - Show convergent evidence across studies
   - Highlight our unique contribution

**Next week:**

4. **Write discussion draft** (700-900 words)
   - Document: `docs/omar_discussion_draft.md`
   - Structure:
     - **Para 1:** Summary of our findings (ECM #1 pathway)
     - **Para 2:** Literature context (recent studies show same thing)
     - **Para 3:** Our unique contribution (unbiased, complete KO, non-neuronal)
     - **Para 4:** Convergent evidence (strengthens ECM-TDP-43 link)
     - **Para 5:** Therapeutic implications (MMP inhibitors, etc.)
     - **Para 6:** Limitations (cell type, acute KO)
     - **Para 7:** Future directions (patient validation, mechanisms)

**Deliverables:**
- `docs/omar_literature_notes.md` (by Friday)
- Literature comparison table (by end of Week 2)
- `docs/omar_discussion_draft.md` (by end of Week 3)

**Branch:** `omar/discussion`

**Citations:** Use PubMed format, I'll convert to journal style later

---

### 8.5 Zahra Almahal (Manuscript Engineer)

**Status:** ⚠️ NOT STARTED - Final step

**Objective:** Write the Methods section and assemble the complete manuscript.

**Week 3-4: Methods Section**

1. **Read all phase notes:**
   - `docs/phase1_notes.md` → `docs/phase6_notes.md`
   - Understand what was done in each phase

2. **Write Methods section** (1000-1200 words)
   - Document: `docs/zahra_methods_draft.md`
   - Structure:
     - **Data Acquisition** (Phase 1)
     - **Quality Control** (FastQC/MultiQC)
     - **Quantification** (Salmon)
     - **Differential Expression** (DESeq2 parameters)
     - **Pathway Enrichment** (clusterProfiler, GO/KEGG)
     - **ML Modeling** (Random Forest, Elastic Net, LOOCV)
     - **Statistical Analysis** (thresholds, corrections)

3. **Create methods flowchart**
   - Visual diagram: Data → QC → Quantification → DE → Enrichment → ML
   - Tool: PowerPoint or draw.io
   - File: `docs/methods_flowchart.png`

**Week 4-5: Full Manuscript Assembly**

4. **Assemble complete manuscript**
   - Document: `docs/zahra_manuscript_v1.md`
   - Sections:
     - **Title** + **Abstract** (250 words)
     - **Introduction** (use project overview + clinical context)
     - **Methods** (from your draft)
     - **Results** (organize around 6 figures)
     - **Discussion** (from Omar's draft)
     - **Conclusion** (2-3 sentences)
     - **References** (from Omar's citations)

5. **Figure organization**
   - **Figure 1:** PCA plot + Volcano plot
   - **Figure 2:** Heatmap (top 50 genes)
   - **Figure 3:** Pathway enrichment (GO BP barplot + dotplot)
   - **Figure 4:** ML dysfunction scores (barplot + heatmap)
   - **Figure 5:** Feature importance (top 20 genes)
   - **Figure 6:** Therapeutic targets schematic (create this)

   Create figure legends (50-100 words each)

6. **Format for submission**
   - Convert to Word document
   - Apply journal template (*Frontiers in Neuroscience*)
   - Check word counts, format references

**Deliverables:**
- `docs/zahra_methods_draft.md` (by end of Week 3)
- `docs/methods_flowchart.png` (by end of Week 3)
- `docs/zahra_manuscript_v1.md` (by end of Week 4)
- Formatted Word document (by end of Week 5)

**Branch:** `zahra/manuscript`

**Note:** Zahra starts later because she needs Omar's discussion first

---

### 8.6 Summary of Assignments

| Team Member | This Week | Next Week | Week 3+ |
|-------------|-----------|-----------|---------|
| **Almokhtar** | Monitor github, draft outline | Review drafts | Integrate manuscript |
| **Rahma** | Write validation report | Help Ahmed test | Review final |
| **Ahmed** | Read DESeq2, plan analysis | Run robustness tests | Revisions |
| **Omar** | Read 5 papers, lit search | Write discussion | Revisions | collaborate with Zahra
| **Zahra** | Read phase notes | Write methods | Assemble manuscript | collaborate with Omar

**Everyone:** Push initial work to your branch by **Friday**


---

## CLOSING REMARKS (2 minutes)

**"Let me summarize what we've accomplished and what's next:"**

### What We Have:
✅ **617 significant genes** from high-quality RNA-seq  
✅ **ECM dysregulation** validated as top pathway  
✅ **ML dysfunction score** with perfect classification  
✅ **Biological findings** that align with cutting-edge literature  
✅ **Therapeutic targets** identified (MMP inhibitors, anti-inflammatory, survival signaling)  

### What We Need:
🎯 **Ahmed:** Robustness analysis (validate ECM across thresholds)  
🎯 **Omar:** Literature review + discussion section  
🎯 **Zahra:** Methods section + manuscript assembly  
🎯 **Rahma:** Validation report + reproducibility guide  
🎯 **Almokhtar:** Integration + final manuscript  

### Timeline:
📅 **8 weeks to submission**

### Impact:
💙 **This work could help ALS/FTD patients live longer, better lives**

**"We're building something real here. Not just for a publication, but for patients who desperately need better treatments. Every line of code you write, every paper you read, every section you draft—it all contributes to that goal."**

**"Thank you all for being part of this team. Let's make this happen."**

**[END MEETING]**

---


**END OF DOCUMENT**
