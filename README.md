# Comparative Species Distribution Modelling of Chordata and Arthropoda in Bristol: Quantifying Flood Risk Impact on Biodiversity Using Explainable Machine Learning

UWE MSc Data Science Individual Project looking at the impact of flooding on biodiversity in Bristol and similar UK cities. 

## Project Overview and Objectives
Flooding is a significant driver of biodiversity disturbance, particularly in urban areas where there are added pressures such as man-made impervious surfaces, modified drainage systems, and a lack of green infrastructure (Ebrahimi, Araujo, & Naimi 2023) (Depietri & McPhearson 2017). Bristol is at increasingly high risk of flooding, despite integrating sustainable flood management techniques (Saunder & Martin 2022). Further to this, climate change is driving and increase in frequency and intensity of flooding globally (Rentschler et al. 2023). Previous research into flood risk on biodiversity has focused on rural, biodiverse areas so research into urban areas is limited. Moreover, quantifying flooding and incorporating this into models has proven difficult (Ebrahimi, Araujo, & Naimi 2023). 

This project aims to answer the research question: do the Environment Agency’s Risk of Flooding from Rivers and Sea (RoFRS) and Risk of Flooding from Surface Water (RoFSW) metrics predict biodiversity in UK cities, such as Bristol, using machine learning approaches? This project is limited geographically to the Bristol, Exeter, Nottingham, Newcastle upon Tyne, and Gateshead regions, using species occurrence records dating from 2000 to present day, and are limited to the phyla Chordata and Arthropoda. These additional cities were required due to small sample size. These cities were selected for their similarity to Bristol in terms of size, flood risk, and topography. Flood risk classification data is sourced from the Environment Agency’s RoFRS dataset and serves as the primary predictor variable of interest. Flood risk for each is categorised as “High”, “Medium”, “Low”, and “Very Low”.  

## Project Objectives

- Use machine learning techniques to generate models that aim to predict biodiversity, using RoFRS flood risk as a primary indicator.
- Evaluate the models to determine their performance and reliability.
- Use explainable AI methods on the models to make the model output interpretable.
- Compare the models in their ability to predict biodiversity, performance, and interpretation.

(flowchart)
## Data Sources
All data used in this project is freely available online for use within its licensing terms. The (Data Sources) file contains a list of all sources.
## Notebook Guide
This project consists of a pipeline generated using the targets package in R and several R Markdown files looking at the results. The descriptions below briefly describe the notebook contents.
### 01 - [Pipeline Setup](link) 
How to access and run the pipeline, as well as notes on its generation and outputs.
### 02 - [Exploring Diversity Indices](link)
Generation and comparison of three different diversity indices: Shannon, Simpson, and Richness. Baseline models created using negative binomial distribution for richness, and beta regression with response transformation for Simpson. 
### 03 - [Random Forest](link)

### 04 - [eXtreme Gradient Boosting](link)

### 05 - [SHapley Additive exPlanations](link)

### 06 - [Descriptive Graphics](link)

## Conclusions

### References
- Ebrahimi, E., Araujo, M.B., and Naimi, B. (2023) Flood susceptibility mapping to improve models of species distributions. Ecological Indicators 157 [Accessed 17 February 2026]
- Depietri, Y., and McPhearson, T. (2017) Integrating the grey, green, and blue in cities: Nature-based solutions for climate change adaptation and risk reduction. Springer Nature Link pp 91-109. [Accessed 17 February 2026]
- Saunders, D., and Martin, J. (2022) The role of green infrastructure in pluvial flood management and the legislation surrounding it: A case study in Bristol, UK. Sustainability 14(21) [Accessed 17 February 2026]
- Rentschler, J., Avner, P., Marconcini, M. et al. (2023) Global evidence of rapid urban growth in flood zones since 1985. Nature 622 pp. 87-92 [Accessed 26 February 2026]

