# ============================================================
# Feature Importance Visualization
# ============================================================

library(ggplot2)
library(dplyr)


# Load feature importance data

importance <- read.csv(
  "results/feature_importance.csv"
)


# Arrange features

importance <- importance %>%
  arrange(Importance)



# Create plot

p <- ggplot(
  importance,
  aes(
    x = Importance,
    y = reorder(Feature, Importance)
  )
) +
  geom_col() +
  theme_minimal() +
  labs(
    title = "Random Forest Feature Importance",
    x = "Importance Score",
    y = "Feature"
  )


# Save plot

ggsave(
  filename = "results/figures/feature_importance_plot.png",
  plot = p,
  width = 8,
  height = 5,
  dpi = 300
)


print("Feature importance figure saved")
