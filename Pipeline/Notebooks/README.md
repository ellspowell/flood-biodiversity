# Notebooks

This directory contains the notebooks used to document, explore, model, and interpret the flood-biodiversity analysis. Rendered PDF version are available [here]() and their corresponding R Markdown (`.Rmd`) files are available in [`RMDs/`](RMDs/) for users who wish to reproduce the analysis.

These notebooks cover:

1. Pipeline structure
2. Exploratory data analysis
3. Baseline Diversity Models
4. Random Forest regression
5. Random Forest classification
6. Random Forest classification without the sampling-effort proxy
7. Extreme Gradient Boosting (XGBoost)
8. SHAP model interpretation

The complete pipeline can also be used to reconstruct these datasets from the original environmental and biodiversity sources. However, the original source datasets require substantial storage and computation and are therefore not distributed through GitHub.

To reproduce the analysis, the recommended workflow is:

```text
Clone the GitHub repository
        ↓
Download the analysis-ready data
        ↓
Place it in Notebooks/RMDs/Data/
        ↓
Restore the R environment with renv
        ↓
Run the required R Markdown notebook
```
Details on how to do this are below. 

---

## Reproducing the notebooks

The original environmental and biodiversity datasets used to construct the analytical grids are too large to distribute through GitHub.

Instead, analysis-ready datasets and saved model objects are provided separately:

[Data](/Pipeline/Notebooks/Data/)

Download the analysis-ready data and place the files in:

```text
Pipeline/Notebooks/RMDs/Data/
```

The R Markdown notebooks use relative paths to this `Data/` directory, so the directory structure described at the end of this README should be retained.

### R environment

The notebooks and full data-processing pipeline share the same [`renv`](https://rstudio.github.io/renv/) environment and is located in:

```text
Pipeline/
```

The package versions used for the analysis are recorded in:

```text
Pipeline/renv.lock
```

To reproduce the software environment, open your terminal in the `Pipeline/` directory and start R. If `renv` is not already installed, run:

```r
install.packages("renv")
```

Then restore the project environment:

```r
renv::restore()
```

This installs the R package versions recorded for the project. Individual notebooks then load the packages they require using their existing `library()` calls.

---

## [01 — Pipeline](/RMDs/01_Pipeline.Rmd)

This notebook describes the structure of the `targets` pipeline used to construct the analysis datasets. It covers the main stages of the pipeline, functions, dependencies, and useful commands for inspecting and running the workflow.

This notebook is primarily intended as documentation of the full data-processing pipeline.

---

## [02 — Exploratory Data Analysis](02_Exploratory_Data_Analysis.pdf)

This notebook explores the final grid-level modelling dataset produced by the pipeline.

The exploratory analysis includes:

- Spatial visualisation of the study grids
- Summary statistics
- Distributions of key variables
- Correlation analysis between model variables

### Required data

```text
Data/grid_model.gpkg
Data/grid_1km_Bristol.gpkg
Data/grid_1km_Exeter.gpkg
Data/grid_1km_Nottingham.gpkg
Data/grid_1km_Newcastle.gpkg
Data/grid_1km_Gateshead.gpkg
Data/OS_borders/
```

---

## [03 — Diversity Indices](03_Diversity_Indices.pdf)

This notebook summarises and evaluates the statistical models used to investigate relationships between environmental variables, flood risk, and biodiversity.

Two biodiversity responses are considered:

- **Species richness**, modelled using negative binomial regression.
- **Simpson diversity**, modelled using beta regression.

Models are compared and evaluated using Akaike Information Criterion (AIC) and likelihood ratio testing.

### Required data

```text
Data/richness_models.rds
Data/simpson_models.rds
```

---

## [04 — Random Forest Regression](04_Random_Forest_Regression.pdf)

This notebook uses Random Forest regression to model:

- Species richness
- Simpson diversity

Model development is carried out using the `tidymodels` recipe and workflow framework to provide a consistent modelling approach.

Hyperparameter tuning and model evaluation include:

- Root mean squared error (RMSE)
- R^2^
- Mean absolute error (MAE)
- City-based cross-validation
- Out-of-bag R^2^ for the final models

Variable importance is also examined.

The notebook additionally investigates `n_days` as a proxy for biodiversity sampling effort by examining its correlation and variation between cities. The models are subsequently refitted without `n_days` to investigate how its removal affects model performance and the importance of environmental predictors.

### Required data

```text
Data/grid_model.gpkg
```

---

## [05 — Random Forest Classification](05_Random_Forest_Classification.pdf)

For comparison with classification approaches used in the existing literature, species richness and Simpson diversity are converted into binary **high** and **low** classes using a median split.

Random Forest classification models are then fitted using the same `tidymodels`-based workflow used previously.

### Required data

```text
Data/grid_model.gpkg
```

---

## [06 — Random Forest Classification Without Sampling Effort](06_Random_Forest_NoDays.pdf)

This notebook extends the Random Forest classification analysis from Notebook 05 by removing `n_days` from the predictor set.

`n_days` is used as a proxy for biodiversity sampling effort. Removing it allows better analysis of the contribution of environmental predictors on biodiversity.

### Required data

```text
Data/grid_model.gpkg
```

---

## [07 — Extreme Gradient Boosting](07_eXtreme_Gradient_Boosting.pdf)

This notebook fits Extreme Gradient Boosting (XGBoost) models for species richness and Simpson diversity. The models use the `tidymodels` recipe and workflow framework to maintain a consistent modelling approach across the machine-learning analyses. Hyperparameter tuning is performed using a Latin hypercube design, allowing a wide range of parameter combinations to be evaluated efficiently.

Models are evaluated using:

- Mean ROC AUC
- Success-rate versus prediction-rate AUC

Variable importance is also examined.

### Required data

```text
Data/grid_model.gpkg
```

---

## 08 — SHapley Additive exPlanations (SHAP)

This notebook uses SHAP values to interpret the species richness Random Forest and XGBoost models fitted without `n_days`. The Random Forest model is interpreted using `kernelshap`, while the XGBoost model uses TreeSHAP. Both analyses explain the predicted probability of high species richness.

Model interpretation includes:

- SHAP feature importance
- SHAP beeswarm plots
- Dependence plots for selected correlated environmental variables.

The dependence analyses include:

- Precipitation and temperature
- Elevation and distance to nearest river

### Required data

```text
Data/grid_model.gpkg
Data/richness_fit_class.rds
Data/richness_fit_xgb_ND.rds
Data/richness_recipe_xgb_ND.rds
```
---

# Expected file structure

The notebooks are designed to use the following directory structure:

```text
Pipeline/
├── _targets.R
├── pipeline_report.Rmd
├── Data_Prep.Rmd
├── renv.lock
├── .Rprofile
├── renv/
├── R/
├── Data/
│   └── ...
│
└── Notebooks/
    ├── README.md
    ├── 01_Pipeline.pdf
    ├── 02_Exploratory_Data_Analysis.pdf
    ├── 03_Diversity_Indices.pdf
    ├── 04_Random_Forest_Regression.pdf
    ├── 05_Random_Forest_Classification.pdf
    ├── 06_Random_Forest_NoDays.pdf
    ├── 07_eXtreme_Gradient_Boosting.pdf
    ├── 08_SHapley_Additive_exPlanations.pdf
    └── RMDs/
        ├── 01_Pipeline.Rmd
        ├── 02_Exploratory_Data_Analysis.Rmd
        ├── 03_Diversity_Indices.Rmd
        ├── 04_Random_Forest_Regression.Rmd
        ├── 05_Random_Forest_Classification.Rmd
        ├── 06_Random_Forest_NoDays.Rmd
        ├── 07_eXtreme_Gradient_Boosting.Rmd
        ├── 08_SHapley_Additive_exPlanations.Rmd
        │
        └── Data/
            ├── grid_1km_Bristol.gpkg
            ├── grid_1km_Exeter.gpkg
            ├── grid_1km_Gateshead.gpkg
            ├── grid_1km_Newcastle.gpkg
            ├── grid_1km_Nottingham.gpkg
            ├── grid_model.gpkg
            ├── richness_fit_class.rds
            ├── richness_fit_xgb_ND.rds
            ├── richness_recipe_xgb_ND.rds
            ├── richness_models.rds
            ├── simpson_models.rds
            └── OS_borders/
                ├── district_borough_unitary_region.dbf
                ├── district_borough_unitary_region.prj
                ├── district_borough_unitary_region.shp
                └── district_borough_unitary_region.shx
```

The two `Data/` directories have different purposes:

- `Pipeline/Data/` contains the source and intermediate data required to rebuild the full geospatial pipeline.
- `Pipeline/Notebooks/RMDs/Data/` contains the smaller analysis-ready datasets and saved model objects required to reproduce the notebook analyses. 

For information on obtaining the original source datasets and running the complete data-processing pipeline, see the [Pipeline README](../README.md).

---


