# =====================================================
# AI-Guided RNA Therapeutic Discovery for SLE
# Script 03: Feature Engineering
# =====================================================


library(dplyr)
library(Seurat)
library(tibble)



# ---------------------------------------
# Load Differential Expression Results
# ---------------------------------------

deg <- read.csv(
  "single_cell/SLE1_cluster_markers.csv"
)



# ---------------------------------------
# Create Gene Features
# ---------------------------------------

gene_features <- deg %>%
  group_by(gene) %>%
  summarise(
    max_log2FC = max(avg_log2FC),
    mean_log2FC = mean(avg_log2FC),
    max_pct1 = max(pct.1),
    mean_pct1 = mean(pct.1),
    min_adj_pvalue = min(p_val_adj),
    cluster_count = n_distinct(cluster)
  )


write.csv(
  gene_features,
  "results/gene_features_reproduced.csv",
  row.names = FALSE
)



# ---------------------------------------
# Cell-type Specificity Feature
# ---------------------------------------


bank_obj <- readRDS(
  "single_cell/SLE_BANK1_annotated.rds"
)


cell_expression <- AverageExpression(
  bank_obj,
  assays = "RNA",
  group.by = "celltype"
)


cell_expression <- as.data.frame(
  cell_expression$RNA
)



gene_specificity <- cell_expression %>%
  rownames_to_column("gene") %>%
  mutate(
    B_cell_specificity_score =
      `Naive-B-cells` /
      rowMeans(
        select(
          .,
          -gene,
          -`Naive-B-cells`
        )
      )
  )



write.csv(
  gene_specificity,
  "results/gene_B_cell_specificity_features.csv",
  row.names = FALSE
)