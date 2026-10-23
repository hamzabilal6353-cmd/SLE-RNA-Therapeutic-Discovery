
# Reconstructed B-cell pseudobulk DE input preparation
# Dataset: GSE174188
#
# Reproduces the saved 284-sample DE count matrix.
# The reason for the original four-batch exclusion
# has not been established.

sample_counts <- readRDS(
  "results/B_cell_sample_pseudobulk_counts.rds"
)

metadata <- read.csv(
  "results/B_cell_pseudobulk_sample_metadata.csv",
  stringsAsFactors = FALSE
)

original_de_counts <- readRDS(
  "results/B_cell_DE_input_counts.rds"
)

excluded_batches <- c(
  "dmx_count_AH7TNHDMXX_YE_8-30",
  "dmx_count_AHCM2CDMXX_YE_0831",
  "dmx_count_BH7YT2DMXX_YE_0907",
  "dmx_YE110"
)

stopifnot(
  !anyDuplicated(metadata$Group_ID),
  all(metadata$Group_ID %in% colnames(sample_counts))
)

keep <- metadata$Group_ID[
  !metadata$Batch %in% excluded_batches
]

reconstructed <- sample_counts[
  , keep, drop = FALSE
]

stopifnot(
  ncol(reconstructed) == 284,
  setequal(
    colnames(reconstructed),
    colnames(original_de_counts)
  ),
  identical(
    reconstructed[
      , colnames(original_de_counts), drop = FALSE
    ],
    original_de_counts
  )
)

cat("Verified: 284 sample groups\n")
cat("Verified: reconstructed counts identical\n")

# Original saved files are not overwritten.
