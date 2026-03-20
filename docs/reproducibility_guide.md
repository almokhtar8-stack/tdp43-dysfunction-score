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
