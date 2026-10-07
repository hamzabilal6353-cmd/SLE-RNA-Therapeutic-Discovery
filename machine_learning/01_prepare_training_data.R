# ============================================================
# SLE Therapeutic Target Discovery
# Step 1: Prepare Machine Learning Training Dataset
# ============================================================


# Load required libraries
library(dplyr)


# ------------------------------------------------------------
# 1. Load engineered transcriptomic features
# ------------------------------------------------------------

data <- read.csv(
  "results/AI_ranked_autoimmune_targets_v3.csv"
)


# Check data
head(data)

dim(data)


# ------------------------------------------------------------
# 2. Create ML Labels
# ------------------------------------------------------------

# Define top 10% therapeutic candidates as positive class

threshold <- quantile(
  data$Therapeutic_Target_Score,
  probs = 0.90
)


data$Target_Label <- ifelse(
  data$Therapeutic_Target_Score >= threshold,
  1,
  0
)


# Check class distribution

table(data$Target_Label)



# ------------------------------------------------------------
# 3. Select ML Features
# ------------------------------------------------------------

ml_data <- data %>%
  select(
    max_log2FC,
    mean_log2FC,
    max_pct1,
    mean_pct1,
    min_adj_pvalue,
    cluster_count,
    Expression_score,
    Disease_score,
    Cell_support_score,
    Expression_frequency_score,
    B_cell_specificity_score,
    Target_Label
  )


# Remove missing values

ml_data <- na.omit(ml_data)


# Check final dataset

dim(ml_data)

head(ml_data)



# ------------------------------------------------------------
# 4. Save prepared dataset
# ------------------------------------------------------------

write.csv(
  ml_data,
  "data/SLE_ML_training_dataset.csv",
  row.names = FALSE
)


print("ML dataset preparation completed successfully")