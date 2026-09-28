# =====================================================
# AI-Guided RNA Therapeutic Discovery for SLE
# Script 04: AI Target Ranking Models
# =====================================================


library(dplyr)



# ---------------------------------------
# Load Feature Dataset
# ---------------------------------------

gene_features <- read.csv(
  "results/gene_features.csv"
)



# ---------------------------------------
# Model 1: Baseline Ranking
# ---------------------------------------

ranked_targets <- gene_features %>%
  mutate(
    
    Expression_score =
      scale(max_log2FC)[,1],
    
    Disease_score =
      scale(mean_log2FC)[,1],
    
    Cell_support_score =
      scale(cluster_count)[,1],
    
    Expression_frequency_score =
      scale(max_pct1)[,1]
    
  ) %>%
  
  mutate(
    
    Therapeutic_Target_Score =
      Expression_score +
      Disease_score +
      Cell_support_score +
      Expression_frequency_score
    
  ) %>%
  
  arrange(
    desc(Therapeutic_Target_Score)
  )


write.csv(
  ranked_targets,
  "results/AI_ranked_therapeutic_targets_reproduced.csv",
  row.names = FALSE
)



# ---------------------------------------
# Model 2: Autoimmune Weighted Ranking
# ---------------------------------------


autoimmune_ranked_targets <- ranked_targets %>%
  
  mutate(
    
    Autoimmune_Target_Score =
      (0.35 * Disease_score) +
      (0.30 * Expression_frequency_score) +
      (0.20 * Expression_score) +
      (0.15 * Cell_support_score)
    
  ) %>%
  
  arrange(
    desc(Autoimmune_Target_Score)
  )



write.csv(
  autoimmune_ranked_targets,
  "results/AI_ranked_autoimmune_targets_v2_reproduced.csv",
  row.names = FALSE
)



# ---------------------------------------
# Model 3: Biology-Aware Ranking
# ---------------------------------------


gene_specificity <- read.csv(
  "results/gene_B_cell_specificity_features.csv"
)


AI_targets_v3 <- autoimmune_ranked_targets %>%
  
  left_join(
    
    gene_specificity %>%
      select(
        gene,
        B_cell_specificity_score
      ),
    
    by = "gene"
    
  )



AI_targets_v3 <- AI_targets_v3 %>%
  
  mutate(
    
    B_cell_specificity_score_scaled =
      scale(B_cell_specificity_score)[,1],
    
    Autoimmune_Target_Score_v3 =
      
      (0.30 * Disease_score) +
      (0.25 * B_cell_specificity_score_scaled) +
      (0.20 * Expression_score) +
      (0.15 * Cell_support_score) +
      (0.10 * Expression_frequency_score)
    
  ) %>%
  
  arrange(
    desc(Autoimmune_Target_Score_v3)
  )



write.csv(
  AI_targets_v3,
  "results/AI_ranked_autoimmune_targets_v3_reproduced.csv",
  row.names = FALSE
)



# Check BANK1 ranking

which(
  AI_targets_v3$gene == "BANK1"
)