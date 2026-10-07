# ============================================================
# SLE Therapeutic Target Discovery
# Step 4: Feature Importance Analysis
# ============================================================


library(randomForest)
library(dplyr)


# Load trained Random Forest model

rf_model <- readRDS(
  "models/random_forest_model.rds"
)


# Extract final random forest object

rf_final <- rf_model$finalModel


# Calculate importance

importance_scores <- importance(
  rf_final
)


# Convert to dataframe

importance_df <- data.frame(
  Feature = rownames(importance_scores),
  Importance = importance_scores[,1]
)


# Sort descending

importance_df <- importance_df %>%
  arrange(desc(Importance))


# View results

print(importance_df)



# Save results

write.csv(
  importance_df,
  "results/feature_importance.csv",
  row.names = FALSE
)


print(
  "Feature importance analysis completed successfully"
)