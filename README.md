# Comparative Species Distribution Modelling of Chordata and Arthropoda in Bristol: Quantifying Flood Risk Impact on Biodiversity Using Explainable Machine Learning

UWE MSc Data Science Individual Project looking at the impact of flooding on biodiversity in Bristol and similar UK cities. 

## Key Findings

- **Flood risk was not a dominant predictor of urban biodiversity.** Greenspace, temperature and precipitation were consistently more influential than the DEFRA Flood risk measures.
- **Sampling effort strongly influenced apparent species richness.** Removing the sampling effort proxy reduced Random Forest OOB $R^{2}$ from 0.606 to 0.302, highlighting a substantial sampling bias in citizen-science biodiversity data.
- **XGBoost was the strongest performing model for species richness** in this project based on mean ROC AUC (0.706), but performance varied across unseen cities. 

## Project Overview 
Flooding is a significant driver of biodiversity disturbance, particularly in urban areas where there are added pressures such as man-made impervious surfaces, modified drainage systems, and a lack of green infrastructure (Ebrahimi, Araujo, & Naimi 2023) (Depietri & McPhearson 2017). Bristol is at increasingly high risk of flooding, despite integrating sustainable flood management techniques (Saunder & Martin 2022). Further to this, climate change is driving and increase in frequency and intensity of flooding globally (Rentschler et al. 2023). Previous research into flood risk on biodiversity has focused on rural, biodiverse areas so research into urban areas is limited. Moreover, quantifying flooding and incorporating this into models has proven difficult (Ebrahimi, Araujo, & Naimi 2023). 

This project aims to answer the research question: do the Environment Agency’s Risk of Flooding from Rivers and Sea (RoFRS) and Risk of Flooding from Surface Water (RoFSW) metrics predict biodiversity in UK cities, such as Bristol, using machine learning approaches? This project is limited geographically to the Bristol, Exeter, Nottingham, Newcastle upon Tyne, and Gateshead regions, using species occurrence records dating from 2000 to present day, and are limited to the phyla Chordata and Arthropoda. These additional cities were required due to small sample size. These cities were selected for their similarity to Bristol in terms of size, flood risk, and topography. Flood risk classification data is sourced from the Environment Agency’s RoFRS dataset and serves as the primary predictor variable of interest. Flood risk for each is categorised as “High”, “Medium”, “Low”, and “Very Low”.  

| Project Area | Approach | 
| ------------ | -------------------------------------- | 
| Study Area | Bristol, Exeter, Nottingham, Newcastle upon Tyne, & Gateshead |
| Taxa | Chordata & Arthropoda |
| Biodiversity Measures | Species richness & Simpson diversity |
| Flood Risk Measures | DEFRA Risk of Flooding from Rivers and Sea (RoFRS) and Risk of Flooding from Surface Water (RoFSW) |
| Pipeline | R `targets` |
| Baseline Models | Negative binomial & Beta regression |
| Machine Learning | Random Forest & XGBoost |
| Explainable AI | Shapley Additive Explanations |

## Project Objectives

- Use machine learning techniques to generate models that aim to predict biodiversity, using RoFRS flood risk as a primary indicator.
- Evaluate the models to determine their performance and reliability.
- Use explainable AI methods on the models to make the model output interpretable.
- Compare the models in their ability to predict biodiversity, performance, and interpretation.

## Project Flowchart
<img width="3780" height="2076" alt="Project Workflow" src="https://github.com/user-attachments/assets/8a95ef30-72c6-4ae2-ad84-9ef10862dda7" />

## Data Sources
All data used in this project is freely available online for use within its licensing terms. The [Data Sources](Data_Sources.md) file contains a list of all sources.

## Notebook Guide
This project consists of a pipeline generated using the targets package in R and several R Markdown files looking at the results. The descriptions below briefly describe the notebook contents, full descriptions and data requirements can be found [here](Pipeline/Notebooks/README.md).

### 01 - [Pipeline Setup](01_Pipeline.pdf) 
How to access and run the pipeline, as well as notes on its generation and outputs.
### 02 - [Exploratory Data Analysis](02_Exploratory_Data_Analysis.pdf)
Exploratory analysis of the grid, predictor variables, distributions, and diversity indices.
### 03 - [Diversity Indices](02_Diversity_Indices.pdf)
Generation and comparison of two different diversity indices: Richness and Simpson. Baseline models created using negative binomial distribution for richness, and beta regression with response transformation for Simpson. 
### 04 - [Random Forest Regression](03_Random_Forest_Regression.pdf)
Regression Random Forest models using richness and Simpson.
### 05 - [Random Forest Classification](04_Random_Forest_Classification.pdf)
Random Forest models for richness and Simpson where diversity is classified as "high" or "low".
### 06 - [Random Forest Classification without Sampling Effort](05_Random_Forest_NoDays.pdf)
Random Forest models for richness and Simpson where diversity is classified as "high" or "low" and sampling effort is removed.
### 07 - [eXtreme Gradient Boosting](06_eXtreme_Gradient_Boosting.pdf)
XGBoost models for richness and Simpson.
### 08 - [SHapley Additive exPlanations](07_sHapley_Additive_exPlanations.pdf)
Notebook using SHAP to interpret machine learning outputs.
### 09 - [Flood Risk Predictor Analysis](09_Flood_Risk.Rmd)
Notebook exploring the role of RoFRS and RoFSW as a predictor of biodiversity.

## Reproducing the analysis
Two approaches can be taken when replicating this analysis:

1. The quickest and simplest: Follow the steps described in the Notebooks [README.md](Pipeline/Notebooks/README.md) to replicate the post pipeline analysis notebooks described above.
2. The full pipeline: Follow the steps described in this [README.md](Pipeline/README.md) to clone the repository, download and prep the data, and run the full pipeline. 

## Limitations

1. Sampling bias - the data used in this project is observational so more frequently surveyed areas have more opportunity for species to be recorded. The importance of `n_days` demonstrates this and its removal doesn't correct the underlying bias. Future work should include means to mitigate this bias, such as rarefraction and extrapolation techniques (Chao *et al*, 2014). 
2. Observation counts are not true abundance which could explain why Simpson diversity was consistently less predictable than species richness.
3. Spatial resolution and data availability constrained the project. The $1km^{2}$ grid resolution was a compromise between fine spatial resolution and each grid cell having enough species observation records to calculate species diversity indices. 

### References
- Ebrahimi, E., Araujo, M.B., and Naimi, B. (2023) Flood susceptibility mapping to improve models of species distributions. Ecological Indicators [online] 157 [Accessed 17 February 2026]
- Depietri, Y., and McPhearson, T. (2017) Integrating the grey, green, and blue in cities: Nature-based solutions for climate change adaptation and risk reduction. Springer Nature Link [online] pp 91-109. [Accessed 17 February 2026]
- Saunders, D., and Martin, J. (2022) The role of green infrastructure in pluvial flood management and the legislation surrounding it: A case study in Bristol, UK. Sustainability [online] 14(21) [Accessed 17 February 2026]
- Rentschler, J., Avner, P., Marconcini, M. *et al.* (2023) Global evidence of rapid urban growth in flood zones since 1985. Nature [online] 622 pp. 87-92 [Accessed 26 February 2026]
- Chao, A., Gotelli, N., Hsieh, T., Sander, E. *et al* (2014) Rarefraction and extrapolation with Hill numbers: a framework for sampling and estimation in species diversity studies. Ecological Monographs [online] 84(1):45-67. [Accessed 20/08/2026]

