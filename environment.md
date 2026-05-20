# Computational Environment

This file contains information about the computational environment used for the organ donor gut microbiome analyses.

## Contents

### List of major software tools and versions used throughout the project.
FastQC v0.11.9
MultiQC v1.28
Trim Galore v0.6.7
Kraken2 v2.1.2
Bracken v2.7
Bowtie2 v2.5.1
SPAdes v3.15.5
metaSPAdes v3.15.5
HUMAnN v3.6
MetaPhlAn v4.0
QUAST v5.2.0
MetaQUAST v5.2.0
samtools v1.17
bcftools v1.17
GATK v4.4
Picard v3.0
DFAST v1.2
DIAMOND v2.1
VSEARCH v2.22
VAMB v4.1
QIIME2 2023.5
R v4.3

## Computational platform

Analyses were primarily performed on a SLURM-based high-performance computing (HPC) cluster using Conda-managed software environments.

## Notes

Some workflow scripts may require modification of:
- database paths
- Conda environment names
- SLURM resource settings
- software module names

before reuse on another system.
