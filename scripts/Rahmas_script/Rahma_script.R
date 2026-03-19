
# Navigating to the GitHub path- the project file tdp43 dysfunction score
(genomics) rorym@Rahma:/home$  cd /mnt/c/Users/rorym/tdp43-dysfunction-score
(genomics) rorym@Rahma:/mnt/c/Users/rorym/tdp43-dysfunction-score$ 

# 1. Create the directory named 'genomics' right here
mkdir genomics

# 2. Enter that new directory
cd genomics

(genomics) rorym@Rahma:/mnt/c/Users/rorym/tdp43-dysfunction-score/genomics$ pwd
/mnt/c/Users/rorym/tdp43-dysfunction-score/genomics

(genomics) rorym@Rahma:/mnt/c/Users/rorym/tdp43-dysfunction-score/genomics$ 

# Create subdirectories for each analysis step
mkdir subsampled_data
mkdir trimmed_data
mkdir references
#you can create multiple folders in the same command:
mkdir -p qc_reports/fastqc_raw qc_reports/fastqc_trimmed qc_reports/fastp
mkdir alignment
mkdir salmon_quant
mkdir counts
mkdir -p results/tables results/figures results/enrichment
mkdir logs

(genomics) rorym@Rahma:/mnt/c/Users/rorym/tdp43-dysfunction-score/genomics$ tree
.
├── alignment
├── counts
├── logs
├── qc_reports
│   ├── fastp
│   ├── fastqc_raw
│   └── fastqc_trimmed
├── references
├── results
│   ├── enrichment
│   ├── figures
│   └── tables
├── salmon_quant
├── subsampled_data
└── trimmed_data

16 directories, 0 files

(genomics) rorym@Rahma:/mnt/c/Users/rorym/tdp43-dysfunction-score/genomics$
