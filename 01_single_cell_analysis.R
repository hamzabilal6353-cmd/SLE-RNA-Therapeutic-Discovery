# =====================================================
# AI-Guided RNA Therapeutic Discovery for SLE
# Script 01: Single Cell RNA-seq Analysis
# =====================================================


library(Seurat)
library(ggplot2)
library(dplyr)


# Load Seurat object

combined <- readRDS(
  "single_cell/SLE_combined_final.rds"
)


# Check Seurat object

combined


# View metadata

head(combined@meta.data)


# Check cell types

table(combined$celltype)


# Generate UMAP plot

umap_plot <- DimPlot(
  combined,
  reduction = "umap",
  group.by = "celltype",
  label = TRUE
)


umap_plot


# Save figure

ggsave(
  "results/figures/SLE_cell_atlas_UMAP_reproduced.png",
  umap_plot,
  width = 10,
  height = 7,
  dpi = 300
)