# ASSEMBLIES

This folder contains reconstructed bacterial genome assemblies, assembly statistics, assembly workflows, and downstream comparative genomics analyses generated from organ donor gut metagenomic sequencing data.

The assemblies were generated from selected donor intestinal samples to investigate genomic diversity, functional adaptation, and niche-specific genomic features across intestinal regions.

## Contents

### Assembly files

Genome assemblies and annotations, including:

- `.fna` : assembled genome FASTA files
- `.gff` : genome annotation files

Assemblies include reconstructed genomes from taxa such as:
- *Bifidobacterium longum*
- *Eggerthella lenta*
- *Collinsella aerofaciens*
- *Escherichia coli*
- *Enterocloster bolteae*
- *Limosilactobacillus fermentum*

## Assembly statistics

Summary assembly metrics are provided in text tables

These files were used for assembly quality assessment and comparative analyses.

## scripts/

Contains workflows and helper scripts used for:
- de novo assembly
- genome annotation
- assembly quality assessment

Main software used includes:
- Bowtie2
- samtools
- bcftools
- QUAST / MetaQUAST
- DFAST
- minimap2
- MUMmer

## post_analysis_visualization/

Contains downstream comparative genomics analyses and visualization resources, including:
- R scripts
- processed comparative tables
- genome comparison outputs
- CAZyme comparison analyses
- circular genome visualization inputs
- phylogenetic visualization resources

These analyses were used for:
- genome similarity comparisons
- niche-associated functional adaptation analyses
- comparative CAZyme profiling
- structural genome visualization
- identification of shared and unique genomic regions

## Notes

- Assemblies were reconstructed from shotgun metagenomic sequencing data.
- Intermediate assembly files and temporary alignment files were excluded from this repository due to file size limitations.
- Some scripts contain cluster-specific paths and HPC resource settings that may require modification before reuse.
