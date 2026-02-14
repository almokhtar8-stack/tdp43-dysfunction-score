# Phase 1 Progress Notes

## 1.1 System Check
**Date:** Feb 14, 2026

- Location: ~/tdp43-dysfunction-score
- Disk: 92GB available (plenty)
- Environment: genomics ✓
- SRA toolkit: 3.2.1 ✓
- Salmon: 1.10.3 ✓

**Status:** ✅ Complete

## 1.2 Ensembl References Downloaded
**Date:** Feb 14, 2026

**Files:**
- Homo_sapiens.GRCh38.cdna.all.fa.gz (175M)
- Homo_sapiens.GRCh38.116.gtf.gz (135M)

**Location:** data/references/
**Status:** ✅ Complete

## 1.3 tx2gene Mapping Created
**Date:** Feb 14, 2026

**Script:** scripts/00_setup/create_tx2gene.R
**Output:**
- Transcripts: 646,577
- Genes: 78,941
- Files: data/references/tx2gene.rds, tx2gene.csv

**Status:** ✅ Complete

## 1.4 SRA Data Downloaded
**Date:** Feb 14, 2026
**Script:** scripts/00_setup/download_sra.sh

**Download time:** 5 hours 10 minutes (02:23 - 07:33)
**Total size:** 67GB (12 files)

**Samples:**
- ✅ SRR10045016-018 (3 KO samples)
- ✅ SRR10045019-021 (3 Rescue samples)

**Verification:**
- File count: 12 ✅
- All .fastq.gz present ✅
- Total size: 67GB ✅

**Status:** ✅ COMPLETE

---

## PHASE 1 SUMMARY
**Date completed:** Feb 14, 2026

**Completed:**
- ✅ 1.1 System check
- ✅ 1.2 Ensembl references (310M)
- ✅ 1.3 tx2gene mapping (646K transcripts → 79K genes)
- ✅ 1.4 SRA data download (67GB, 6 samples)

**Ready for Phase 2:** Salmon quantification
