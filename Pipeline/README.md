# Pipeline Guide

This guide contains the data-processing and modelling pipeline for the flood and biodiversity analysis.

There are two ways to reproduce this project:

1. Reproduce the statistical analysis using the pipeline generated datasets. Information on this can be found [here](Notebooks/README.md).
2. Rebuild the datasets from the original source data. This requires downloading large datasets and running the full `targets` pipeline.

Option one is recommended for users who want to reproduce the project results. For information on how the pipeline is built visit this [notebook](../01_Pipeline.pdf).

# Rerunning the pipeline

## 1. Clone the repository

Clone the repository rather than downloading individual R scripts:

```
git clone https::/github.com/ellspowell/flood-biodiversity.git
cd flood-biodiversity/Pipeline
```
Alternatively, the repository can be downloaded as a ZIP from GitHub.

## 2. Restore the R environment

This project uses `renv` to record the R package versions used for the analysis. The project was developed used R 4.5.3. 
From the `Pipeline` directory, start R and install `renv` if not already installed:

```r
install.packages("renv")
```

Then restore the project environment:

```r
renv::restore()
```

This then installs the package versions recorded in `renv.lock`.

## 3. Download the data sources

> **Note:** This requires substantial data downloads, storage, and computation. For this reason, the original source datasets are not included in this GitHub repository. 

This pipeline expects data to be stored relative to the `Pipeline` directory under:

```
Pipeline/
├── _targets.R
├── pipeline_report.Rmd
├── renv.lock
└── R/
    ├── Grid.R
    ├── Species_Diversity.R
    └── Baseline_Model.R
└── Data/
```
Do not change the working directory within `_targets.R` since all paths used by the pipeline are relative to the `Pipeline` directory.

The datasets in this project are listed below. Further details on data sources can be found [here](../Data_Sources.md).

### NBN Atlas Species Data
Species occurrence data was obtained from the NBN Atlas. Data can be downloaded through **Locations -> Explore by predefined area -> [area] -> View records**. 

Records can be filtered by variables such as record type, species group, and year. Large searches may need to be downloaded in multiple parts.

The downloaded occurrence datasets were then processed and combined using [`Data_Prep.Rmd`](Data_Prep.Rmd) to produce: 

`Data/Species_Data.csv`

Users downloading NBN Atlas data should observe the licences and attribution requirements associated with the downloaded records and datasets. 

### OS UK Borders
Download the ESRI Shapefile version of OS Boundary-Line from the OS Data hub. 

The pipeline expects data to be stored under:

`Data/OS_borders/`

### OS Greenspace
Download OS Open Greenspace from the OS Data Hub in ESRI Shapefile format.

The pipeline expects:

`Data/OS_greenspace/GB_GreenspaceSite.shp`

### OS GB Rivers
Download OS Open Rivers from the OS Data Hub in ESRI Shapefile format.

The pipeline expects:

`Data/OS_rivers_gb/data/WatercourseLink.shp`

### Risk of Flooding from Rivers and Seas
Download the Environment Agency Risk of Flooding from Rivers and Sea data for each study area in ESRI Shapefile format.

The separate downloads are processed and combined using [`Data_Prep.Rmd`](../Pipeline/Data_Prep.Rmd).

The pipeline expects the resulting dataset at:

`Data/rofrs_data/rofrs_data_all.shp`

### Risk of Flooding from Surface Water
Download the Environment Agency Risk of Flooding from Surface Water data for each study area in ESRI Shapefile format.

The separate downloads are processed and combined using [`Data_Prep.Rmd`](Data_Prep.Rmd).

The pipeline expects:

`Data/rofsw_data/rofsw_data.shp`

### National LIDAR Programme
LiDAR Digital Terrain Model (DTM) data were downloaded from the Environment Agency National LiDAR Programme.

For each study area:

1. Select the area of interest.
2. Select the available DTM tiles.
3. Download the required tiles.
4. Store the downloaded ZIP files under:

`Data/lidar/`

The pipeline automatically identifies ZIP files within this directory and constructs the elevation data required for each study area.

### National Forest Inventory
Download the National Forest Inventory for England in ESRI Shapefile format.

The pipeline expects the data under:

`Data/National_Forest_Inventory_England_2023/`

### National Trees Outside Woodlands
Download the appropriate Trees Outside Woodland layer for each study area.

For example, the South West layer covers Bristol and Exeter.

The separate datasets are processed and combined using [`Data_Prep.Rmd`](Data_Prep.Rmd).

The resulting dataset is expected under:

`Data/trees_outside_woodland_data/`

### Impervious Density
Imperviousness Density data were obtained from the Copernicus Land Monitoring Service. A Copernicus account may be required to download the data.

Select the United Kingdom as the area of interest and store the downloaded ZIP files under:

`Data/Impervious_Density_UK_2024/`

The pipeline automatically identifies the ZIP files and processes the required imperviousness data for each study area.

### Annual Temperature Observations
Annual temperature observations for 1991–2020 were obtained from the Met Office Climate Data Portal.

Download the data in ESRI Shapefile format and store them under:

`Data/Annual_Temperature_Observations_1991_2020/`

### Annual Precipitation Observations
Annual precipitation observations for 1991–2020 were obtained from the Met Office Climate Data Portal.

Download the data in ESRI Shapefile format and store them under:

`Data/Annual_Precipitation_Observations_1991_2020/`


## 4. Data Preparation
Some downloads require preprocessing before running the pipeline. Use [`Data_Prep.Rmd`](Data_Prep.Rmd) to prepare:

- NBN Atlas Species Data
- Risk of Flooding from Rivers and Sease
- Risk of Flooding from Surface Water
- National Trees Outside Woodland

After preparation, the expected data structure is:

```
Pipeline/
├── _targets.R
├── pipeline_report.Rmd
├── Data_Prep.Rmd
├── renv.lock
├── .Rprofile
├── renv/
└── R/
    ├── Grid.R
    ├── Species_Diversity.R
    └── Baseline_Model.R
└── Data/
    ├── Annual_Precipitation_Observations_1991_2020/
    ├── Annual_Temperature_Observations_1991_2020/
    ├── Impervious_Density_UK_2024/
    ├── lidar/
    ├── National_Forest_Inventory_England_2023/
    ├── OS_Borders/
    ├── OS_greenspace/
    ├── OS_rivers_gb/
    ├── rofrs_data/
    ├── rofsw_data/
    ├── trees_outside_woodland_data/
    └── Species_Data.csv
└── Notebooks/    
```
## 5. Run the pipeline

From the `Pipeline` directory, start R and run:

```r
targets::tar_make()
```

There is no need to manually run individual lines from `_targets.R`. On the first complete run, `targets` builds the required analysis from the source data. On subsequent runs, `targets` identifies changes and rebuild affected targets and their downstream dependencies.

The complete pipeline is computationally intensive. In particular, processing the LiDAR and imperviousness data can take susbstantial time and require significant disk space. 

## Study areas

The study areas used in this project are defined in `_targets.R`:

```r
cities <- tibble::tibble(
  city_name  = c("City of Bristol (B)", "Gateshead District (B)", "Newcastle upon Tyne District (B)", "Exeter District (B)", "City of Nottingham (B)"),
  city_label = c("Bristol", "Gateshead", "Newcastle", "Exeter", "Nottingham"))
```
The pipeline uses British National Grid (ESPG:27700) as the project coordinate reference system. Changing the study areas may require additional source data covering the new locations and editing the cities table. 

## Reproducibility

The repository contains three components intended to support reproducibility:

- `renv.lock` records the R package environment used for the project.
- `_targets.R` and `R/` contain the complete computational workflow used to construct the analysis datasets.
- Analysis read grids preseve the datasets used for statistical modellling without requiring users to repeat the large source-data downloads and computationally expensive geospatial processing.

Original datasets are not stored in this GitHub repository due to their size and, where applicable, external licensing and redistribution requirements. 
