# ============================================================
# SLE Therapeutic Target Discovery
# ML Visualization
# ============================================================

library(ggplot2)
library(dplyr)


# Create figure folder if missing

dir.create(
  "results/figures",
  showWarnings = FALSE
)


# ------------------------------------------------------------
# Feature Importance Plot
# ------------------------------------------------------------

importance <- read.csv(
  "results/feature_importance.csv"
)


importance <- importance %>%
  arrange(Importance)



feature_plot <- ggplot(
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


ggsave(
  filename = "results/figures/feature_importance_plot.png",
  plot = feature_plot,
  width = 8,
  height = 5,
  dpi = 300
)


print("Feature importance plot created")
