# Validation Report: TDP-43 Project
**Author:** Rahma
**Date:** 2026-03-19

## Overview
This report documents the resolution of technical issues encountered during the Chromosome 14 RNA-seq analysis.

## Key Resolutions
1. **Drive Mounting:** Fixed WSL mount issues for the H: drive.
2. **Data Integrity:** Re-downloaded and compressed `SRR10045019_2.fastq` to fix file corruption.
3. **Environment:** Corrected pathing errors between PowerShell and WSL.

## Current Status
- Scripts organized in `scripts/Rahmas_script`
- Salmon index built (with warnings addressed)
