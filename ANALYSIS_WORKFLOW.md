# SLE B-Cell Analysis Workflow

## Dataset

Public single-cell RNA-seq dataset: [GSE174188](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE174188).

## Analysis Overview

The project investigates transcriptomic differences between B cells from patients with systemic lupus erythematosus (SLE) and healthy controls.

### 1. B-Cell Pseudobulk Preparation

Relevant scripts:

- `single_cell/05_B_cell_pseudobulk_checkpoints.R`
- `single_cell/06_combine_B_cell_checkpoints.R`

The downstream differential-expression analysis uses pseudobulk counts and corresponding sample metadata.

### 2. Donor-Aware Differential Expression

Relevant script:

- `single_cell/09_B_cell_donor_aware_reconstructed.R`

The analysis uses limma-voom, adjusts for sequencing batch, and accounts for repeated samples from individual donors.

The original analysis tested 7,917 genes, identifying 1,586 genes at FDR < 0.05.

The original source script was unavailable as executable code. A reconstruction was prepared, but independent execution from a clean environment has not yet been demonstrated.

### 3. Gene Ontology Enrichment

Results:

- `results/B_cell_GO_BP_enrichment.csv`
- `results/B_cell_interferon_candidate_table.csv`

Gene Ontology enrichment identified 94 significant Biological Process terms. Interferon-associated immune pathways were examined to inform candidate selection.

### 4. Candidate Gene Assessment

Six candidate genes were investigated:

**TLR7, USP18, JAK1, JAK2, IFIH1, STAT1**

Relevant results:

- `results/B_cell_six_target_combined_evidence.csv`
- `results/B_cell_six_target_filtering_sensitivity.csv`

These genes are exploratory candidates, not experimentally validated therapeutic targets.

### 5. Sensitivity Analysis

Relevant script:

- `single_cell/12_B_cell_filtering_sensitivity.R`

Pseudobulk samples containing fewer than 100 B cells were excluded.

The filtered analysis retained 259 samples and tested 7,712 genes.

All six candidate genes retained their expression directions and remained significant at FDR < 0.05.

### 6. Visualization

Relevant scripts:

- `single_cell/10_B_cell_volcano_plot.R`
- `single_cell/11_B_cell_top_genes.R`

Figures are stored under `results/figures/`.

### 7. Software Environment

See `docs/R_session_info.txt` for recorded R session details.

## Reproducibility Limitations

The repository currently provides analysis scripts, selected summary outputs, and documentation. Some large upstream inputs are maintained locally rather than published.

The workflow should not yet be described as independently reproduced end-to-end from raw sequencing data.

## Scientific Limitations

The study is observational and computational. It does not demonstrate causal therapeutic effects or clinical efficacy. Independent cohorts, protein-level investigation, and functional experiments are required.
## B-cell pseudobulk input reconstruction

The saved sample-level pseudobulk count matrix contains 25,716 genes across 347 sample groups. The original differential-expression input matrix contains 25,716 genes across 284 sample groups.

Comparison of the saved matrices identified 63 excluded sample groups, comprising 47 Healthy and 16 SLE Managed groups. All excluded groups came from four batches:

- `dmx_count_AH7TNHDMXX_YE_8-30`: 16 groups
- `dmx_count_AHCM2CDMXX_YE_0831`: 15 groups
- `dmx_count_BH7YT2DMXX_YE_0907`: 16 groups
- `dmx_YE110`: 16 groups

A reconstructed script, `single_cell/05_B_cell_DE_input_reconstructed.R`, reproduces the original 284-sample count matrix exactly by excluding these batches.

**Reproducibility limitation:** The original reasons for excluding these four batches have not been established. The reconstructed script reproduces the saved DE input matrix from existing pseudobulk counts; it does not reproduce aggregation from raw single-cell data. The original upstream preparation scripts were not preserved and should not be represented as working code.
