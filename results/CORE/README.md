# CORE

This folder contains analyses related to the cohort-level intestinal core microbiome identified across human organ donor gut samples.

A cohort-level intestinal core microbiome was defined using:
- relative abundance threshold: 0.0001
- prevalence threshold: 50%

Core taxa analyses were performed to identify microbial species consistently present across intestinal regions and ecological niches.

## Contents

### Core taxa tables

Processed abundance and prevalence tables for:
- core species
- accessory species
- segment-specific core taxa
- donor-level summaries

## Scripts

Contains scripts and helper files used for:
- core microbiome identification
- prevalence filtering
- abundance thresholding
- statistical analyses
- visualization generation

Visualization resources include:
- dot plots
- stacked bar plots
- abundance summaries


## Notes

- Relative abundance values were calculated from processed taxonomic abundance tables generated using Kraken2 and Bracken.
- Core taxa definitions were applied at the cohort level unless otherwise specified.
- Intestinal segments included:
  - Duodenum
  - Jejunum
  - Ileum
  - Ascending colon
  - Transverse colon
  - Descending colon

- Both luminal and mucosal samples were included in the analyses when available.
