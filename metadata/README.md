# Metadata

This folder contains sample metadata associated with the organ donor gut microbiome study.

## Files

### `220801_UNC41-A00434_0518_BHNJ5KDSX3-ODI.mapping.txt`

Main metadata table containing sample-level information for all shotgun metagenomic samples.

### `Samples.txt`

List of sample identifiers included in the study.

---

# Study Design

Samples were collected from multiple intestinal segments across human organ donors.

For each donor, samples were collected from:

- Duodenum
- Jejunum
- Ileum
- Ascending colon
- Transverse colon
- Descending colon

Both luminal and mucosal niches were sampled when available.

---

# Metadata Variables

| Variable | Description |
|---|---|
| SampleID | Unique sequencing sample identifier |
| Donor | Organ donor identifier |
| Milieu | Sampling niche (Lumen or Mucosa) |
| Tissue | Intestinal segment |
| Tissue_numbered | Ordered intestinal segment label |
| Tissue_Milieu | Combined tissue and niche label |
| Section | Broad intestinal region (Small_intestine or Large_intestine) |
| Section_Milieu | Combined section and niche label |
| Gender | Donor sex |
| Age | Donor age in years |
| Age_group | Age category |
| ROD | Reason of death |
| Hs | Estimated proportion of host-associated reads |
| Hs_group | Host-read abundance category |
| HS_CAT | Host-read classification category |
| Uncl | Fraction of unclassified reads |
| Uncl_group | Unclassified-read abundance category |

---

# Notes

- Sample identifiers beginning with `ODIWGS` correspond to individual shotgun metagenomic sequencing libraries.
- Intestinal segments are ordered anatomically from proximal small intestine to distal colon.
- Metadata were used for downstream diversity, taxonomic, functional, AMR, and assembly analyses.

---

# Example

| SampleID | Donor | Tissue | Milieu |
|---|---|---|---|
| ODIWGS90 | OD1 | Duodenum | Lumen |
| ODIWGS87 | OD1 | Duodenum | Mucosa |
