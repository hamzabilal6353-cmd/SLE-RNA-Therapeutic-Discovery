# SLE-RNA-Therapeutic-Discovry
AI-guided RNA therapeutic target discovery for Systemic Lupus Erythematosus using single-cell transcriptomics
# Machine Learning-Based SLE Therapeutic Target Discovery Using Single-Cell Transcriptomic Features


## Overview

This project develops a computational framework for prioritizing potential therapeutic targets in Systemic Lupus Erythematosus (SLE) using single-cell RNA sequencing features and machine learning approaches.

The workflow integrates transcriptomic analysis, biological feature engineering, stability-based feature selection, and interpretable machine learning models to identify important molecular characteristics associated with high-confidence therapeutic candidates.


## Workflow

Single-cell RNA-seq Data

↓

Differential Expression Analysis

↓

Biological Feature Engineering

↓

Therapeutic Target Ranking

↓

Stability-Based Feature Selection

↓

Machine Learning Model Training

↓

Feature Importance Analysis


## Computational Methodology


### Feature Engineering

Gene-level features were generated from single-cell transcriptomic analysis, including:

- Differential expression magnitude
- Expression prevalence
- Cluster distribution
- Cell-type support
- B-cell specificity


### Stability-Based Feature Selection

A repeated LASSO-based stability selection approach was implemented.

The procedure:

1. Randomly samples 80% of the dataset repeatedly.
2. Applies LASSO regularization for feature selection.
3. Records feature selection frequency.
4. Identifies consistently selected biological predictors.


Features with high selection stability were considered robust predictors for downstream machine learning.


## Machine Learning Models

Selected features were evaluated using:

- Logistic Regression
- Random Forest


Model performance was assessed using ROC-AUC.


## Results


### Model Performance

| Model | ROC-AUC |
|------|---------|
| Logistic Regression | 1.00 |
| Random Forest | 0.998 |


### Important Features

Random Forest feature importance identified:

1. max_log2FC
2. Cell_support_score
3. cluster_count
4. max_pct1
5. mean_log2FC


These features represent expression magnitude, cellular support, and biological relevance.


