# ============================================================
# SLE Therapeutic Target Discovery
# Step 3: Machine Learning Model Training
# ============================================================


# Load libraries

library(caret)
library(randomForest)
library(pROC)
library(dplyr)



# ------------------------------------------------------------
# 1. Load ML dataset
# ------------------------------------------------------------

ml_data <- read.csv(
  "data/SLE_ML_training_dataset.csv"
)



# Convert target variable to factor

ml_data$Target_Label <- factor(
  ml_data$Target_Label,
  levels = c(0,1)
)



# ------------------------------------------------------------
# 2. Select stable independent features
# ------------------------------------------------------------

stable_features <- c(
  "max_log2FC",
  "mean_log2FC",
  "max_pct1",
  "mean_pct1",
  "min_adj_pvalue",
  "cluster_count",
  "B_cell_specificity_score"
)



model_data <- ml_data %>%
  select(
    all_of(stable_features),
    Target_Label
  )



# ------------------------------------------------------------
# 3. Scale numerical features
# ------------------------------------------------------------

model_data[,stable_features] <- scale(
  model_data[,stable_features]
)



# ------------------------------------------------------------
# 4. Train/Test Split
# ------------------------------------------------------------

set.seed(123)


train_index <- createDataPartition(
  model_data$Target_Label,
  p = 0.80,
  list = FALSE
)


train_data <- model_data[train_index, ]

test_data <- model_data[-train_index, ]



# ------------------------------------------------------------
# 5. Logistic Regression Model
# ------------------------------------------------------------

logistic_model <- train(
  Target_Label ~ .,
  data = train_data,
  method = "glm",
  family = "binomial"
)



# ------------------------------------------------------------
# 6. Random Forest Model
# ------------------------------------------------------------

rf_model <- train(
  Target_Label ~ .,
  data = train_data,
  method = "rf",
  importance = TRUE
)



# ------------------------------------------------------------
# 7. Generate Predictions
# ------------------------------------------------------------


logistic_prob <- predict(
  logistic_model,
  test_data,
  type = "prob"
)[,2]



rf_prob <- predict(
  rf_model,
  test_data,
  type = "prob"
)[,2]



# ------------------------------------------------------------
# 8. ROC-AUC Evaluation
# ------------------------------------------------------------


roc_logistic <- roc(
  response = test_data$Target_Label,
  predictor = logistic_prob,
  levels = c("0","1")
)



roc_rf <- roc(
  response = test_data$Target_Label,
  predictor = rf_prob,
  levels = c("0","1")
)



# ------------------------------------------------------------
# 9. Model Performance Results
# ------------------------------------------------------------


model_results <- data.frame(
  
  Model = c(
    "Logistic Regression",
    "Random Forest"
  ),
  
  ROC_AUC = c(
    auc(roc_logistic),
    auc(roc_rf)
  )
  
)



print(model_results)



# ------------------------------------------------------------
# 10. Save Results
# ------------------------------------------------------------


write.csv(
  model_results,
  "results/model_performance.csv",
  row.names = FALSE
)



# Save trained models

saveRDS(
  logistic_model,
  "models/logistic_model.rds"
)



saveRDS(
  rf_model,
  "models/random_forest_model.rds"
)



print(
  "Machine learning models trained successfully"
)
)