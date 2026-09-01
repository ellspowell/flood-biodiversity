# Comparative Species Distribution Modelling of Chordata and Arthropoda: Quantifying Flood Risk Impact on Biodiversity Using Explainable Machine Learning

UWE MSc Data Science Individual Project looking at the impact of flooding on biodiversity in Bristol and similar UK cities. 

## Key Findings

- **Flood risk was not a dominant predictor of urban biodiversity.** Across the fitted models, greenspace, temperature, and precipitation were generally more influential predictors than the DEFRA flood-risk measures.
- **Sampling effort strongly influenced apparent species richness.** In the Random Forest richness model, removing the sampling-effort proxy (n_days) reduced out-of-bag OOB $R^{2}$  from 0.606 to 0.302. This demonstrates the importance of sampling bias when modelling citizen-science biodiversity records.
- **XGBoost was the strongest performing model for species richness,** achieving a mean ROC AUC of 0.706. However, predictive performance varied when models were evaluated on geographically unseen cities, indicating limitations in their spatial generalisability.

## Project Overview 
Flooding is a significant driver of biodiversity disturbance, particularly in urban areas where there are added pressures such as man-made impervious surfaces, modified drainage systems, and a lack of green infrastructure (Ebrahimi, Araujo, & Naimi 2023) (Depietri & McPhearson 2017). Bristol is at increasingly high risk of flooding, despite integrating sustainable flood management techniques (Saunders & Martin 2022). Further to this, climate change is driving an increase in frequency and intensity of flooding globally (Rentschler et al. 2023). 

Previous research into flood risk on biodiversity has focused on rural, biodiverse areas so research into urban areas is limited. Moreover, quantifying flooding and incorporating this into models has proven difficult (Ebrahimi, Araujo, & Naimi 2023). 

Therefore, this project asks the following research question:

> **Do the Environment Agency’s Risk of Flooding from Rivers and Sea (RoFRS) and Risk of Flooding from Surface Water (RoFSW) metrics predict biodiversity in UK cities, such as Bristol, using machine learning approaches?** 

The study covers Bristol, Exeter, Nottingham, Newcastle upon Tyne, and Gateshead. The additional cities increase the number of spatial observations available for modelling and allow model performance to be evaluated outside of Bristol.

Species occurrence records are from 2000-2026, restricted to the phyla Chordata and Arthropoda. Biodiversity is represented by species richness and Simpson diversity.

Flood risk is represented using DEFRAs RoFRS and RoFSW data. These flood-risk variables are the primary predictors of interest. Environmental and sampling related variables are included to build a bigger ecological picture.

| Project Area | Approach | 
| ------------ | -------------------------------------- | 
| Study Area | Bristol, Exeter, Nottingham, Newcastle upon Tyne, & Gateshead |
| Taxa | Chordata & Arthropoda |
| Biodiversity Measures | Species richness & Simpson diversity |
| Flood Risk Measures | DEFRA Risk of Flooding from Rivers and Sea (RoFRS) and Risk of Flooding from Surface Water (RoFSW) |
| Pipeline | R `targets` |
| Baseline Models | Negative binomial & Beta regression |
| Machine Learning | Random Forest & XGBoost |
| Explainable AI | SHapley Additive exPlanations |

## Project Objectives

- Use machine learning techniques to generate models that aim to predict biodiversity, using RoFRS flood risk as a primary indicator.
- Evaluate the models to determine their performance and reliability.
- Use explainable AI methods on the models to make the model output interpretable.
- Compare the models in their ability to predict biodiversity, performance, and interpretation.

## Project Flowchart
Flow chart showing the stages of this project.
<img width="3780" height="2076" alt="Project Workflow" src="https://github.com/user-attachments/assets/1a93ae91-2d12-4a21-bbad-2fadeeba5951" />

## Data Sources
All data used in this project is freely available online for use within its licensing terms. The [Data Sources](Data_Sources.md) file contains a list of all sources.

## Reproducing the analysis
This repository contain two main components:

- An R `targets` pipeline for processing data, constructing and populating the grids, and calculating the baseline models.
- R Markdown notebooks containing the exploratory analysis, statistical modelling, machine learning models, and model interpretation.

There are two ways to reproduce the project:

1. **Notebook analysis only** This is the quickest approach. Follow the instructions in the [Notebooks README](Pipeline/Notebooks/README.md) to reproduce the post pipeline analyses using the prepared data.
2. **Full reproduction** Follow the [Pipeline README](Pipeline/README.md) to clone the repository, obtain and prepare the source datasets, run the `targets` pipeline, and reproduce the subsequent analyses.

## Notebook Guide
This analysis is divided into a series of R Markdown notebooks. More detailed descriptions and data requirements are provided in the [Notebooks README](Pipeline/Notebooks/README.md).

### 01 - [Pipeline Setup](01_Pipeline.pdf) 
How to access and run the pipeline, as well as notes on its generation and outputs.
### 02 - [Exploratory Data Analysis](02_Exploratory_Data_Analysis.pdf)
Exploratory analysis of the spatial grid, predictor variables, data distributions, and biodiversity indices.
### 03 - [Diversity Indices](03_Diversity_Indices.pdf)
Generation and comparison of two different diversity indices: Richness and Simpson. Baseline models created using negative binomial distribution for richness, and beta regression with transformation for Simpson. 
### 04 - [Random Forest Regression](04_Random_Forest_Regression.pdf)
Regression Random Forest models using species richness and Simpson diversity.
### 05 - [Random Forest Classification](05_Random_Forest_Classification.pdf)
Random Forest models for species richness and Simpson diversity where diversity is classified as "high" or "low".
### 06 - [Random Forest Classification without Sampling Effort](06_Random_Forest_NoDays.pdf)
Random Forest models for species richness and Simpson diversity where diversity is classified as "high" or "low" and sampling effort is removed.
### 07 - [eXtreme Gradient Boosting](07_eXtreme_Gradient_Boosting.pdf)
XGBoost models for species richness and Simpson diversity.
### 08 - [SHapley Additive exPlanations](08_sHapley_Additive_exPlanations.pdf)
Notebook using SHAP to interpret machine learning outputs.
### 09 - [Flood Risk Predictor Analysis](09_Flood_Risk.Rmd)
Notebook exploring the role of RoFRS and RoFSW as a predictor of biodiversity.

## Limitations

1. Sampling bias - the data used in this project is observational so more frequently surveyed areas have more opportunity for species to be recorded. The importance of `n_days` demonstrates this and its removal doesn't correct the underlying bias. Future work should include means to mitigate this bias, such as rarefaction and extrapolation techniques (Chao *et al*, 2014). 
2. Observation counts are not true abundance which could explain why Simpson diversity was consistently less predictable than species richness.
3. Spatial resolution and data availability constrained the project. The $1km^{2}$ grid resolution was a compromise between fine spatial resolution and each grid cell having enough species observation records to calculate species diversity indices.

## Conclusion

Overall, the results indicate that flood-risk measures alone do not fully predict biodiversity patterns across the five urban study areas. Instead models identified strong associations with environmental predictors, while the comparatively low importance of direct flood-risk measures suggests their contribution is minimal. Consequently, the findings demonstrate associations, not causal effects, between flood-related environmental predictors and biodiversity.

### References
- Ebrahimi, E., Araujo, M.B., and Naimi, B. (2023) Flood susceptibility mapping to improve models of species distributions. Ecological Indicators [online] 157 [Accessed 17 February 2026]
- Depietri, Y., and McPhearson, T. (2017) Integrating the grey, green, and blue in cities: Nature-based solutions for climate change adaptation and risk reduction. Springer Nature Link [online] pp 91-109. [Accessed 17 February 2026]
- Saunders, D., and Martin, J. (2022) The role of green infrastructure in pluvial flood management and the legislation surrounding it: A case study in Bristol, UK. Sustainability [online] 14(21) [Accessed 17 February 2026]
- Rentschler, J., Avner, P., Marconcini, M. *et al.* (2023) Global evidence of rapid urban growth in flood zones since 1985. Nature [online] 622 pp. 87-92 [Accessed 26 February 2026]
- Chao, A., Gotelli, N., Hsieh, T., Sander, E. *et al* (2014) Rarefraction and extrapolation with Hill numbers: a framework for sampling and estimation in species diversity studies. Ecological Monographs [online] 84(1):45-67. [Accessed 20/08/2026]

