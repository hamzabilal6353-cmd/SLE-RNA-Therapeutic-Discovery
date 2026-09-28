library(Seurat)
library(ggplot2)
library(dplyr)

sce <- readRDS(
  "single_cell/SLE_BANK1_annotated.rds"
)

sce

head(sce@meta.data)

table(sce$celltype)