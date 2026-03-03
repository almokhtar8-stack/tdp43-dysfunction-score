# TDP-43 Dysfunction Score Project
## First Team Meeting - Notes

**Date:** 02/03/2026 
**Time:** 9 - 10 pm 
**Duration:** 60 minutes  
**Location:** Google meet
**Prepared by:** Almokhtar Aljarodi

---

## 📋 ATTENDEES

- ✅ Almokhtar Aljarodi (Project Lead)
- ✅ Rahma Abufoor (Reproducibility Lead)
- ✅ Ahmed Bukhamsin (Statistical Robustness)
- ✅ Zahra Almahal (Manuscript Engineer)

---

## 🎯 MEETING OBJECTIVES

1. Present project overview and progress to date
2. Explain ML modeling approach and results
3. Assign specific tasks to all team members
4. Establish timeline for manuscript submission

---

## 📊 PROJECT STATUS UPDATE

### Completed Work (Phases 1-6)

**Phase 1: Data Download ✅**
- 6 RNA-seq samples downloaded (67GB, GSE136366)
- 646,577 transcripts mapped to 78,941 genes
- Completed: Feb 14, 2026

**Phase 2: Salmon Quantification ✅**
- Average mapping rate: 92.69% (excellent quality)
- 349M total reads processed
- Completed: Feb 14, 2026

**Phase 3: Differential Expression ✅**
- 16,536 genes analyzed with DESeq2
- **617 significant genes identified** (padj < 0.05, |log2FC| > 1)
- 488 upregulated in KO (79%) - confirms TDP-43 repressor function
- 129 downregulated in KO (21%)
- Completed: Feb 14, 2026

**Phase 4: Visualization ✅**
- 5 publication-quality figures generated
- PCA: 84% variance on PC1 (strong biological signal)
- Perfect sample clustering, no batch effects
- Completed: Feb 14, 2026

**Phase 6: Pathway Enrichment ✅**
- **KEY FINDING:** ECM organization = #1 pathway (22 genes, p.adj = 0.009)
- Validates recent literature (Fernández-Galiana 2024, Hipke 2023, Cheung 2024)
- Convergent evidence across cell types, species, methods
- Secondary findings: inflammatory response, PI3K-Akt survival pathway
- Completed: Feb 14, 2026

**Phase 5: ML Dysfunction Score ✅**
- Random Forest: ROC = 1.0 (perfect classification)
- Elastic Net: ROC = 1.0 (independent validation)
- SVM: Failed (expected with n=6)
- LOOCV cross-validation used (gold standard for small samples)
- Scores: KO = 96.8-97.6, Rescue = 0.8-2.6
- Completed: Feb 17, 2026

**Rahma's Validation ✅**
- Successfully cloned repository
- Reran entire pipeline
- Confirmed: 617 genes, 92.69% mapping rate
- Pipeline is fully reproducible

---

## 🤖 ML MODEL DISCUSSION

### Why Traditional ML (Not Deep Learning)?

**Decision rationale:**
- Only 6 samples available (deep learning requires 500+ samples)
- Deep learning would overfit with n=6
- Random Forest + Elastic Net = industry standard for genomics with small n
- Provides interpretable feature importance (critical for drug targets)

### Models Tested

1. **Random Forest (Best):**
   - 500 decision trees, ensemble averaging
   - ROC = 1.0, perfect classification
   - Feature importance: ECM genes dominate top ranks

2. **Elastic Net (Validation):**
   - Linear regression with L1/L2 penalties
   - ROC = 1.0, independent confirmation
   - Automatic feature selection

3. **SVM (Failed):**
   - Expected failure with 617 features ÷ 6 samples
   - Demonstrates limits even for traditional ML

### Key ML Findings

1. **Perfect Classification:** ROC = 1.0 in both models
2. **ECM Genes Dominate:** TMEM63C (#1), IGFN1 (#5), FNDC7 (#8) - validates Phase 6
3. **TARDBP Autoregulation:** TARDBP ranked #10 - model rediscovered known mechanism
4. **Cryptic Neuronal Program:** SYN1 (#2), GABRA1 (#9) - neuronal genes in non-neuronal cells
5. **Inflammatory Axis:** TNFRSF10D (#15) - confirms pathway enrichment

### ROC = 1.0: Addressing Concerns

**Question raised:** Is perfect classification suspicious?

**Answer:**
- NOT overfitting - strong biological signal (84% PC1 variance)
- Extreme comparison: complete KO vs full rescue (ON/OFF switch)
- Validated 3 ways: RF, Elastic Net, feature importance matches biology
- LOOCV ensures no sample trained on itself
- Effect sizes huge (log2FC up to ±7)

**Reviewer response prepared:** (1) LOOCV used, (2) two models confirm, (3) biology validates, (4) extreme experimental design expected to yield strong signal

---

## 📅 TIMELINE

### Past Milestones
- Feb 11: Project initiated
- Feb 14: Phases 1-4, 6 complete
- Feb 17: Phase 5 complete
- Feb 14-Mar 2: Rahma validation complete

### Future Timeline (8 weeks to submission) "flexible"

| Week | Tasks | Owner |
|------|-------|-------|
| 1 | Robustness analysis kickoff | Ahmed |
| 1-2 | Threshold testing + sensitivity analysis | Ahmed |
| 2-3 | Literature review + discussion draft | Omar |
| 3-4 | Methods section + manuscript structure | Zahra |
| 4-5 | Integration + manuscript v1.0 | Almokhtar |
| 5-6 | Team review + revisions | Everyone |
| 6-7 | Final manuscript preparation | Zahra + Almokhtar |
| 8 | **SUBMISSION** | Almokhtar |

**Target Journal:** *Frontiers in Neuroscience* (open access)
**Backup Journals:** *Scientific Reports*, *PLOS One*

---

## ✅ DECISIONS MADE

1. **Flexible timeline to manuscript submission** - Agreed by all
2. **Weekly Friday check-ins** - Not decided
3. **Communication:** WhatsApp for quick questions, GitHub Issues for technical problems

---

## 📝 ACTION ITEMS

### 8.1 Almokhtar (Project Lead)
**This Week:**
- [ ] Monitor all team branches daily
- [ ] Review Rahma's validation report (provide feedback)
- [ ] Create threshold testing script template for Ahmed
- [ ] Be available on WhatsApp for questions
- [ ] Draft manuscript outline (section structure + figure order)


---

### 8.2 Rahma Abufoor (Reproducibility Lead)
**Status:** ✅ Primary validation work COMPLETE

**This Week:**
- [ ] Write formal validation report (`docs/rahma_validation_report.md`)
  - Document setup process, results comparison, issues encountered
  - Conclusion: "Pipeline is reproducible"
- [ ] Create reproducibility guide (`docs/reproducibility_guide.md`)
  - Environment setup
  - How to run pipeline
  - Expected runtime for each phase
  - Common errors + solutions

**Next Week:**
- [ ] Test Ahmed's robustness analysis workflow
- [ ] Verify Ahmed's results


---

### 8.3 Ahmed Bukhamsin (Statistical Robustness)
**Status:** ⚠️ NOT STARTED - **HIGHEST PRIORITY**

**Objective:** Test if 617-gene list and ECM pathway are robust to different statistical thresholds

**This Week:**
- [ ] Read `docs/phase3_notes.md`
- [ ] Read DESeq2 vignette (understand padj, log2FC thresholds)
- [ ] Write robustness plan (`docs/ahmed_robustness_plan.md`)
- [ ] Create script: `scripts/07_robustness/test_thresholds.R`

**Thresholds to Test:**
1. padj < 0.05, |log2FC| > 1 (current baseline - 617 genes)
2. padj < 0.01, |log2FC| > 1 (stricter p-value)
3. padj < 0.05, |log2FC| > 1.5 (stricter fold-change)

**For Each Threshold:**
- Count significant genes
- Run GO enrichment
- Check if ECM is still top pathway
- Create comparison table

**Key Question:** Is ECM still #1 pathway across all thresholds?

**Expected Result:** ECM should remain top pathway (validates robustness)

**Deliverables:**
- [ ] `docs/ahmed_robustness_plan.md` (by Wednesday)
- [ ] `scripts/07_robustness/test_thresholds.R` (by Friday)
- [ ] `docs/ahmed_robustness_results.md` (by end of Week 2)
- [ ] Comparison table (CSV file)

**Note:** Almokhtar will provide script template

---

### 8.4 Omar Buqes (Biological Interpretation) collaboration with Zahra
**Status:** ⚠️ NOT STARTED - Critical for manuscript

**Objective:** Connect ECM findings to TDP-43/ALS/FTD literature, write discussion

**This Week:**
- [ ] Read 5 key papers from `docs/phase6_notes.md`:
  - Fernández-Galiana et al. (2024, JCI Insight)
  - Hipke et al. (2023)
  - Cheung et al. (2024)
  - Kaplan et al. (2024)
  - Sun et al. (2020)
- [ ] Broader PubMed literature search:
  - "TDP-43 extracellular matrix"
  - "TDP-43 ECM ALS"
  - "TDP-43 fibronectin"
  - Find 5-10 additional papers
- [ ] Document notes: `docs/omar_literature_notes.md`
- [ ] Create comparison table:
  - Columns: Study | Cell Type | TDP-43 Perturbation | ECM Findings | Methods

**Week 2-3:**
- [ ] Write discussion draft (700-900 words): `docs/omar_discussion_draft.md`

**Structure:**
1. Summary of our findings
2. Literature context
3. Our unique contribution
4. Convergent evidence
5. Therapeutic implications
6. Limitations
7. Future directions

**Deliverables:**
- [ ] `docs/omar_literature_notes.md` (by Friday)
- [ ] Literature comparison table (by end of Week 2)
- [ ] `docs/omar_discussion_draft.md` (by end of Week 3)

**Note:** Use PubMed citation format

---

### 8.5 Zahra Almahal (Manuscript Engineer) collaboration with Omar
**Status:** ⚠️ NOT STARTED - Final assembly step

**Objective:** Write Methods section, assemble complete manuscript

**Week 3-4: Methods Section**
- [ ] Read all phase notes (`docs/phase1_notes.md` → `phase6_notes.md`)
- [ ] Write Methods section (1000-1200 words): `docs/zahra_methods_draft.md`

**Sections:**
- Data Acquisition
- Quality Control (FastQC/MultiQC)
- Quantification (Salmon)
- Differential Expression (DESeq2 parameters)
- Pathway Enrichment (clusterProfiler, GO/KEGG)
- ML Modeling (Random Forest, Elastic Net, LOOCV)
- Statistical Analysis (thresholds, corrections)

- [ ] Create methods flowchart: `docs/methods_flowchart.png`
  - Visual: Data → QC → Quantification → DE → Enrichment → ML
  - Tool: PowerPoint or draw.io

**Week 4-5: Full Manuscript**
- [ ] Assemble manuscript: `docs/zahra_manuscript_v1.md`

**Sections:**
- Title + Abstract (250 words)
- Introduction
- Methods
- Results (organize around 6 figures)
- Discussion (from Omar)
- Conclusion (2-3 sentences)
- References

**Figures:**
- Figure 1: PCA + Volcano
- Figure 2: Heatmap (top 50 genes)
- Figure 3: Pathway enrichment
- Figure 4: ML dysfunction scores
- Figure 5: Feature importance
- Figure 6: Therapeutic targets schematic

- [ ] Format for submission (Word, *Frontiers* template)

**Deliverables:**
- [ ] `docs/zahra_methods_draft.md` (by end of Week 3)
- [ ] `docs/methods_flowchart.png` (by end of Week 3)
- [ ] `docs/zahra_manuscript_v1.md` (by end of Week 4)
- [ ] Formatted Word document (by end of Week 5)



---

## 📊 ASSIGNMENT SUMMARY TABLE

| Member | This Week | Next Week | Week 3+ | Branch |
|--------|-----------|-----------|---------|--------|
| **Almokhtar** | Monitor, outline | Review drafts | Integrate | 
| **Rahma** | Validation report | Help Ahmed | Review final | 
| **Ahmed** | Read, plan, script | Run tests | Revisions | 
| **Omar** | Read 5 papers, lit search | Discussion draft | Revisions | 
| **Zahra** | Read phase notes | Methods draft | Assemble manuscript | 


---

## 📌 KEY RESOURCES

**GitHub Repository:** https://github.com/almokhtar8-stack/tdp43-dysfunction-score

**Essential Reading:**
- `README.md` - Full project summary
- `docs/phase5_notes.md` - ML model details
- `docs/phase6_notes.md` - Pathway enrichment + ECM findings
- `docs/project_summary.md` - Complete overview

**Git Workflow:**
```bash
git clone https://github.com/almokhtar8-stack/tdp43-dysfunction-score
cd tdp43-dysfunction-score
git checkout YOUR_BRANCH
# work on files
git add docs/YOUR_FILE.md
git commit -m "description"
git push origin YOUR_BRANCH
```

---

## 💬 COMMUNICATION CHANNELS

**WhatsApp Group:** Quick questions, daily updates, urgent issues  
**GitHub Issues:** Technical problems, code issues  


---

## 🎯 PROJECT IMPACT

**Clinical Problem:**
- ALS/FTD: no cure, 2-5 year survival, late diagnosis
- No biomarkers for progression or treatment response

**Our Solution:**
- 617-gene ML dysfunction score (0-100)
- Enables: early detection, progression prediction, treatment monitoring, trial enrichment

**Scientific Achievement:**
- ECM dysregulation validated as core TDP-43 function
- Convergent evidence across multiple independent studies
- Therapeutic targets identified: MMP inhibitors, anti-inflammatory drugs, PI3K-Akt modulators

**Ultimate Goal:** Help ALS/FTD patients live longer, better lives


---

## 📋 POST-MEETING TODO (Almokhtar)

Within 24 hours:
- [ ] Send meeting notes to all team members
- [ ] Share GitHub branch links
- [ ] Provide Ahmed's script template



📚 KEY DOCS:
- README: github.com/almokhtar8-stack/tdp43-dysfunction-score

❓ STUCK? Message Almokhtar!
```

---

## ✅ MEETING SUMMARY

**Accomplished:**
- ✅ Presented complete project overview (Phases 1-6)
- ✅ Explained ML approach and ROC = 1.0 rationale
- ✅ Assigned specific tasks to all team members
- ✅ Defined communication channels

**Pending:**
- ⏳ Weekly meeting time (needs vote)
- ⏳ Team members start assigned work
- ⏳ Friday: first progress checkpoint

**Key Takeaway:** Strong foundation established. All phases 1-6 complete with excellent results. ECM dysregulation validated as core finding. Team assignments clear. On track for 8-week submission timeline.

---

**Meeting adjourned:** [Time]  
**Notes prepared by:** Almokhtar Aljarodi  
**Distribution:** All team members via email + GitHub

---

**END OF MEETING NOTES**
