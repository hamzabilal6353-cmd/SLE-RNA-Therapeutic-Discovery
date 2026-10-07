# ============================================================
# SLE Therapeutic Target Discovery
# Step 2: Stability-Based Feature Selection
# ============================================================


# Load libraries

library(caret)
library(glmnet)
library(dplyr)


# ------------------------------------------------------------
# 1. Load prepared ML dataset
# ------------------------------------------------------------

ml_data <- read.csv(
  "data/SLE_ML_training_dataset.csv"
)


# Separate features and target

X <- ml_data %>%
  select(-Target_Label)

y <- ml_data$Target_Label



# ------------------------------------------------------------
# 2. Standardize features
# ------------------------------------------------------------

X_scaled <- scale(X)



# ------------------------------------------------------------
# 3. Stability Selection using repeated LASSO
# ------------------------------------------------------------


set.seed(123)


iterations <- 100


feature_selection_count <- 
  setNames(
    rep(0, ncol(X_scaled)),
    colnames(X_scaled)
  )



for(i in 1:iterations){
  
  
  # Random sampling
  
  train_index <- sample(
    1:nrow(X_scaled),
    size = 0.8*nrow(X_scaled)
  )
  
  
  X_train <- X_scaled[train_index, ]
  
  y_train <- y[train_index]
  
  
  
  # LASSO model
  
  lasso_model <- cv.glmnet(
    X_train,
    y_train,
    family = "binomial",
    alpha = 1
  )
  
  
  # Extract selected features
  
  coefficients <- coef(
    lasso_model,
    s = "lambda.min"
  )
  
  
  selected_features <- rownames(
    coefficients
  )[which(
    coefficients[,1] != 0
  )]
  
  
  selected_features <- 
    selected_features[
      selected_features != "(Intercept)"
    ]
  
  
  
  # Count selections
  
  feature_selection_count[selected_features] <-
    feature_selection_count[selected_features] + 1
  
  
}



# ------------------------------------------------------------
# 4. Calculate stability score
# ------------------------------------------------------------


stability_results <- data.frame(
  
  Feature = names(feature_selection_count),
  
  Selection_Count = feature_selection_count,
  
  Stability_Score =
    feature_selection_count / iterations
  
)



# Sort highest stability first

stability_results <- stability_results %>%
  arrange(desc(Stability_Score))



# View results

head(stability_results)



# ------------------------------------------------------------
# 5. Save results
# ------------------------------------------------------------


write.csv(
  stability_results,
  "results/stability_feature_selection_results.csv",
  row.names = FALSE
)


print(
  "Stability feature selection completed successfully"
)