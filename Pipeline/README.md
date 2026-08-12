# How to run the pipeline

This guide outlines how to set up and run the pipeline. For information on how the pipeline is set up visit this [notebook](../Notebooks/01_Pipeline.pdf).

## Step One
Download the following files:

- [_targets.R](_targets.R)
- [R/Grid.R](R/Grid.R)
- [R/Species_Diversity.R](R/Species_Diversity.R)
- [R/Baseline_Model.R](R/Baseline_Model.R)

Save these to your device with the following format:

```
CSCT_Pipeline/
├── _targets.R
├── pipeline_report.Rmd
└── R/
    ├── Grid.R
    ├── Species_Diversity.R
    └── Baseline_Model.R
└── Data/
```

## Step Two
Download the data. 

### NBN Atlas Species Data
Following this [link](https://nbnatlas.org/), you can download species occurrence data through a number of routes. The easiest way is to go to "Locations" -> "Explore by predefined area" -> "Bristol" -> "View records". At this stage you can filter for record type, species type, year, and many others. Some searches may be too large, but you can filter and download in chunks. Then use the [Data Prep](Data_Prep.Rmd) markdown file to filter and join the datasets. 

### OS UK Borders
Follow this [link](https://osdatahub.os.uk/data/downloads/open/BoundaryLine) to download the ESRI Shapefile.

### OS Greenspace
Follow this [link](https://osdatahub.os.uk/data/downloads/open/OpenGreenspace) to download the ESRI Shapefile.

### OS GB Rivers
Follow this [link](https://osdatahub.os.uk/data/downloads/open/OpenRivers) to download the ESRI Shapefile.

### Risk of Flooding from Rivers and Seas
Follow this [link](https://environment.data.gov.uk/dataset/96ab4342-82c1-4095-87f1-0082e8d84ef1) and select "Download data by area of interest and format". Draw a polygon for your selected area, select "rofrs_4band", and download in an ESRI Shapefile format. Repeat for all areas of interest. Then use the [Data Prep](Data_Prep.Rmd) markdown file to join the datasets. 

### Risk of Flooding from Surface Water
Follow this [link](https://environment.data.gov.uk/dataset/b5aaa28d-6eb9-460e-8d6f-43caa71fbe0e) and select "Download data by area of interest and format". Draw a polygon for your selected area, select "rofrs_4band", and download in an ESRI Shapefile format. Repeat for all areas of interest. Then use the [Data Prep](Data_Prep.Rmd) markdown file to join the datasets. 

### National LIDAR Programme
Follow this [link](https://environment.data.gov.uk/dataset/13787b9a-26a4-4775-8523-806d13af58fc) then click on "download the survey data".
Draw a polygon around your city of interest and click "get available tiles". Select "LIDAR Tiles DTM" for 2017 with a 1m resolution. Available tiles will then be listed, download all. A full list of the tiles downloaded and used in this project is available [here](DTM_Tiles_List).

### National Forest Inventory
Follow this [link](https://data-forestry.opendata.arcgis.com/datasets/0682c7cb180e4abe9dee7e4d5cc35784_0/explore?location=52.433465%2C-2.554283%2C4.00) to download the ESRI Shapefile.

### National Trees Outside Woodlands
Follow this [link] to download the data. Draw a polygon around the area of interest and set the layers to the appropriate location (i.e. FR_TOW_V1_South_West for Bristol or Exeter). Download as an ESRI Shapefile and repeat for all areas of interest. Then use the [Data Prep](Data_Prep.Rmd) markdown file to join the datasets. 

### Impervious Density
Follow this [link](https://land.copernicus.eu/en/products/high-resolution-layer-imperviousness/imperviousness-density-2024#download) to download the data. You will need to create an account before you can download. Follow the steps on the website and use UK as the area selection.

### Annual Temperature Observations
Follow this [link](https://climatedataportal.metoffice.gov.uk/datasets/55e3e3d6178b4739b5ab9f7fc7a6c539_2/explore?location=51.457102%2C-2.267964%2C8) to download the ESRI Shapefile.

### Annual Precipitation Observations
Follow this [link](https://climatedataportal.metoffice.gov.uk/datasets/f6ed302049894ee8b230215a3efa9c19_0/explore?location=51.506706%2C-2.304219%2C9) to download the ESRI Shapefile.


## Step Three
As noted earlier, prepare the following data sets using this [RMD](Data_Prep.Rmd):

- NBN Atlas Species Data
- ROFRS
- ROFSW
- National Trees Outside Woodland

Save these to the `CSCT_Pipeline/Data` Folder. Your files should now be saved in this format:

```
CSCT_Pipeline/
├── _targets.R
├── pipeline_report.Rmd
└── R/
    ├── Grid.R
    ├── Species_Diversity.R
    └── Baseline_Model.R
└── Data/
    ├── Annual_Precipitation_Observations_1991_2020
    ├── Annual_Temperature_Observations_1991_2020
    ├── Impervious_Density_UK_2024
    ├── lidar
    ├── National_Forest_Inventory_England_2023
    ├── OS_Borders
    ├── OS_greenspace
    ├── OS_rivers_gb
    ├── rofrs_data
    ├── rofsw_data
    ├── trees_outside_woodland_data
    └── Species_Data
```

## Step Four
Install the required packages, using the code below:

```r
required_packages <- c("readr", "sf", "dplyr", "terra", "tidyr", "tidyverse", "vegan", "ggplot2", "MASS", "betareg", "ranger")

new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

if (length(new_packages) > 0) {install.packages(new_packages)}
```

## Step Five
1. Open the `_target.R` file.
2. Run the first seven lines of code
   ```r
   library(targets)
   library(tarchetypes)
   setwd("~/CSCT_Pipeline")

   tar_option_set(packages = c("readr", "sf", "dplyr", "terra", "tidyr", "tidyverse", "vegan",    "ggplot2", "MASS", "betareg", "ranger"))
   tar_source()
   project_crs <- 27700
   ```
3. Run the command `tar_make()` in the console. On first run, this will run the entire pipeline. Subsequent runs will only run targets that have been changed and any targets downstream of this change.

NB: Running this pipeline can take a long time due to the large computational requirements of calculating the elevation and imperviousness of each grid square. As such, comments within the pipeline (in `_targets.R`) exist to help with commenting these out for a quicker proof of concept run. 

## Changing Cities

Cities of interest can be altered easily, so long as they fall within the UK, by changing city name in the `_targets.R` file:

```
cities <- tibble::tibble(
  city_name  = c("City of Bristol (B)", "Gateshead District (B)", "Newcastle upon Tyne District (B)", "Exeter District (B)", "City of Nottingham (B)"),
  city_label = c("Bristol", "Gateshead", "Newcastle", "Exeter", "Nottingham"))
```
