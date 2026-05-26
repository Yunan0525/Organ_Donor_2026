# Organ donor gut microbiome analysis

This repository contains processed OTU/taxonomic abundance tables, sample metadata, and analysis scripts used for the organ donor gut microbiome study.

# Data Availability

The host-filtered shotgun metagenomic sequencing data, generated after removing *Homo sapiens*-derived reads from the raw FASTQ files, are available in the NCBI Sequence Read Archive (SRA) under BioProject accession **PRJNA1470551**.

# Organ Donor Gut Microbiome Multi-Omics Analysis Pipeline

The repository includes workflows for:

- Taxonomic profiling
- Functional profiling
- Antimicrobial resistance (AMR) analysis
- Metagenomic assembly and annotation
- Genome reconstruction and refinement
- Correlation analysis (Ccrepe)
- Visualization and downstream statistical analyses

---

# Repository Structure

```text
organ-donor-2026/
├── README.md
├── metadata/
│   ├── sample_metadata.tsv
│   └── README.md
├── scripts/
│   ├── scripts/
│   └── README.md
├── results/
│   ├── README.md
│   ├── BRACKEN/
│   ├── CARD/
│   ├── SYSTEMATICS/
│   ├── ASSEMBLIES/
│   ├── CORE/
│   ├── ECs/
│   └── CORRELATION/
└── environment/
```
# Citation

If you use this repository, please cite the associated manuscript and relevant software resources.
