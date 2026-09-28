# =====================================================
# AI-Guided RNA Therapeutic Discovery for SLE
# Script 02: BANK1 Target Validation
# =====================================================


library(Seurat)
library(ggplot2)
library(dplyr)


# Load Seurat object

bank_obj <- readRDS(
  "single_cell/SLE_BANK1_annotated.rds"
)


# Check object

bank_obj


# -------------------------------
# BANK1 Feature Plot
# -------------------------------

BANK1_feature_plot <- FeaturePlot(
  bank_obj,
  features = "BANK1",
  reduction = "umap"
)


BANK1_feature_plot


ggsave(
  "results/figures/BANK1_FeaturePlot_reproduced.png",
  BANK1_feature_plot,
  width = 8,
  height = 7,
  dpi = 300
)



# -------------------------------
# BANK1 Violin Plot
# -------------------------------

BANK1_violin_plot <- VlnPlot(
  bank_obj,
  features = "BANK1",
  group.by = "celltype",
  pt.size = 0
)


BANK1_violin_plot


ggsave(
  "results/figures/BANK1_ViolinPlot_reproduced.png",
  BANK1_violin_plot,
  width = 10,
  height = 7,
  dpi = 300
)



# -------------------------------
# BANK1 cell-type expression
# -------------------------------

BANK1_expression <- FetchData(
  bank_obj,
  vars = c("BANK1", "celltype")
)


BANK1_celltype_summary <- BANK1_expression %>%
  group_by(celltype) %>%
  summarise(
    Mean_BANK1_Expression = mean(BANK1),
    Median_BANK1_Expression = median(BANK1),
    Number_of_Cells = n()
  )


BANK1_celltype_summary



write.csv(
  BANK1_celltype_summary,
  "results/BANK1_celltype_expression_features_reproduced.csv",
  row.names = FALSE
)