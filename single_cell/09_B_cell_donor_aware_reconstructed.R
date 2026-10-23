
# Reconstructed B-cell donor-aware differential expression
# Dataset: GSE174188
# Comparison: SLE versus Healthy

library(edgeR)
library(limma)

# Load pseudobulk inputs
counts <- readRDS(
  "results/B_cell_DE_input_counts.rds"
)

metadata <- readRDS(
  "results/B_cell_DE_input_metadata.rds"
)

# Align samples
counts <- counts[
  ,
  as.character(metadata$Group_ID),
  drop = FALSE
]

stopifnot(
  identical(
    colnames(counts),
    as.character(metadata$Group_ID)
  )
)

# Prepare design
metadata$Disease <- factor(
  metadata$Disease,
  levels = c("Healthy", "SLE")
)

metadata$Batch <- factor(metadata$Batch)

design <- model.matrix(
  ~ Batch + Disease,
  data = metadata
)

stopifnot(qr(design)$rank == ncol(design))

# Filter and normalize genes
dge <- DGEList(counts = counts)

dge <- dge[
  filterByExpr(dge, design = design),
  ,
  keep.lib.sizes = FALSE
]

dge <- calcNormFactors(dge)

# Estimate correlation between repeated donor samples
v <- voom(dge, design, plot = FALSE)

corfit <- duplicateCorrelation(
  v,
  design,
  block = metadata$Donor
)

# Recalculate precision weights
v <- voom(
  dge,
  design,
  block = metadata$Donor,
  correlation = corfit$consensus.correlation,
  plot = FALSE
)

# Fit donor-aware model
fit <- lmFit(
  v,
  design,
  block = metadata$Donor,
  correlation = corfit$consensus.correlation
)

fit <- eBayes(fit)

# Extract SLE versus Healthy results
de_results <- topTable(
  fit,
  coef = "DiseaseSLE",
  number = Inf,
  adjust.method = "BH",
  sort.by = "none"
)

cat("Genes tested:", nrow(de_results), "\n")
cat(
  "FDR-significant genes:",
  sum(de_results$adj.P.Val < 0.05),
  "\n"
)

cat(
  "Donor correlation:",
  corfit$consensus.correlation,
  "\n"
)

# Save separately; do not overwrite original results
write.csv(
  de_results,
  "results/B_cell_reconstructed_donor_aware_DE.csv",
  row.names = TRUE
)
