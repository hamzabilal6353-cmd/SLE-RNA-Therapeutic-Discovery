
# SLE B-cell donor-aware sensitivity analysis
# Dataset: GEO GSE174188

library(edgeR)
library(limma)

# Run from the project root directory.
metadata <- readRDS(
  "results/B_cell_DE_input_metadata.rds"
)

counts <- readRDS(
  "results/B_cell_DE_input_counts.rds"
)

# Retain samples with at least 100 B cells
keep <- !is.na(metadata$B_Cell_Count) &
  metadata$B_Cell_Count >= 100

md <- metadata[keep, , drop = FALSE]

cts <- counts[
  ,
  as.character(md$Group_ID),
  drop = FALSE
]

stopifnot(
  identical(colnames(cts), as.character(md$Group_ID))
)

md$Disease <- factor(
  md$Disease,
  levels = c("Healthy", "SLE")
)

md$Batch <- factor(md$Batch)

# Build batch-adjusted design
design <- model.matrix(~ Batch + Disease, data = md)

stopifnot(qr(design)$rank == ncol(design))

# Expression filtering and normalization
dge <- DGEList(counts = cts)

dge <- dge[
  filterByExpr(dge, design = design),
  ,
  keep.lib.sizes = FALSE
]

dge <- calcNormFactors(dge)

# Account for repeated donors
v <- voom(dge, design, plot = FALSE)

corfit <- duplicateCorrelation(
  v,
  design,
  block = md$Donor
)

v <- voom(
  dge,
  design,
  block = md$Donor,
  correlation = corfit$consensus.correlation,
  plot = FALSE
)

fit <- lmFit(
  v,
  design,
  block = md$Donor,
  correlation = corfit$consensus.correlation
)

fit <- eBayes(fit)

# Extract differential-expression results
de <- topTable(
  fit,
  coef = "DiseaseSLE",
  number = Inf,
  adjust.method = "BH",
  sort.by = "none"
)

# Compare six selected candidates
genes <- c(
  "TLR7", "USP18", "JAK1",
  "JAK2", "IFIH1", "STAT1"
)

original <- read.csv(
  "results/B_cell_SLE_vs_Healthy_DE_results.csv",
  row.names = 1
)

stopifnot(
  all(genes %in% rownames(original)),
  all(genes %in% rownames(de))
)

comparison <- data.frame(
  Gene = genes,
  Original_logFC = original[genes, "logFC"],
  Filtered_logFC = de[genes, "logFC"],
  Original_FDR = original[genes, "adj.P.Val"],
  Filtered_FDR = de[genes, "adj.P.Val"],
  row.names = NULL
)

comparison$Same_Direction <- with(
  comparison,
  sign(Original_logFC) == sign(Filtered_logFC)
)

comparison$Filtered_Significant <-
  comparison$Filtered_FDR < 0.05

comparison$logFC_Difference <-
  comparison$Filtered_logFC -
  comparison$Original_logFC

write.csv(
  comparison,
  "results/B_cell_six_target_filtering_sensitivity.csv",
  row.names = FALSE
)

print(comparison)
