# Scripts

This folder contains workflow and analysis scripts used for the organ donor gut microbiome study.

The scripts were originally developed for a SLURM-based high-performance computing environment and may contain project-specific paths, database locations, and Conda environment names. Users may need to modify these paths before running the scripts on another system.

## Script overview

| Script | Description |
|---|---|
| `master.sh` | Main workflow script for preprocessing, taxonomic profiling, read extraction, assembly, functional profiling, and variant-calling job submission. |
| `base.sh` | Base preprocessing workflow including FastQC, Trim Galore, Kraken2/Bracken, extraction of unclassified and non-host reads, and HUMAnN submission. |
| `kraken-only.sh` | Simplified workflow for FastQC, trimming, Kraken2 profiling, and host-read removal. |
| `build-ref-indices.sh` | Builds reference genome indices and auxiliary files for Bowtie2, samtools, Picard, and GFF processing. |
| `humann.sh` | HUMAnN functional profiling workflow, including gene family, EC, CPM, relative abundance, MetaPhlAn, DIAMOND CARD, and VSEARCH CARD outputs. |
| `humann-base.sh` | Simplified HUMAnN workflow without additional CARD profiling steps. |
| `card-nonhost.sh` | AMR profiling workflow using non-host reads and CARD reference sequences with VSEARCH. |
| `amr-kraken.sh` | Kraken2/Bracken taxonomic profiling of AMR-associated read sets. |
| `meta-assem.sh` | Metagenomic assembly workflow using metaSPAdes, ResMiCo, Kraken2, BLAST, DFAST, MetaQUAST, and VAMB. |
| `meta-assem-large.sh` | Large-memory version of the metagenomic assembly workflow. |
| `denovo-assem-refine-ann.sh` | De novo isolate-style assembly, variant-based refinement, QUAST assessment, and DFAST annotation. |
| `algn-assem-refine-ann.sh` | Alignment-guided assembly and refinement workflow using Bowtie2, bcftools, GATK, QUAST, and DFAST. |
| `hy-assem-refine-ann.sh` | Hybrid/reference-assisted assembly workflow combining reference-aligned reads, unaligned reads, SPAdes assembly, refinement, QUAST, and DFAST. |
| `vc.sh` | GATK-based variant-calling workflow with read alignment, duplicate marking, base recalibration, and SNP/INDEL filtering. |
| `vc-bcf.sh` | Lightweight bcftools-based variant-calling workflow. |

## General workflow

The overall computational workflow included:

1. Raw-read quality control using FastQC.
2. Adapter and quality trimming using Trim Galore.
3. Taxonomic classification using Kraken2.
4. Taxonomic abundance estimation using Bracken.
5. Host and unclassified read extraction.
6. Functional profiling using HUMAnN.
7. AMR profiling using CARD, DIAMOND, and VSEARCH.
8. Genome assembly using SPAdes/metaSPAdes.
9. Assembly refinement and quality assessment using GATK, bcftools, QUAST, and MetaQUAST.
10. Genome annotation using DFAST.
11. Metagenomic binning using VAMB.
12. Downstream statistical analysis and visualization using R.

## Notes

These scripts are provided to document the computational workflow used in the study. They are not intended to be a fully portable software package. Before reuse, users should update:

- input and output directories
- database paths
- Conda environment names
- SLURM resource requests
- sample identifiers

Large reference databases and raw sequencing files are not included in this repository.
