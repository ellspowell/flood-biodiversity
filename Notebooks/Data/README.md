# Data Information

This folder contains the data needed to run the notebooks. You will also need to download the OS UK Borders data for the `02_Exploratory_Data_Analysis` notebook. Details on how to download this are available [here](https://osdatahub.os.uk/data/downloads/open/BoundaryLine).

These R Markdown files are set up to run using the following file structure:

```
RMDs/
├── 01_Pipeline.Rmd
├── 02_Exploratory_Data_Analysis.Rmd
├── 03_Diversity_Indices.Rmd
├── 04_Random_Forest_Regression.Rmd
├── 05_Random_Forest_Classification.Rmd
├── 06_Random_Forest_NoDays.Rmd
├── 07_eXtreme_Gradient_Boosting.Rmd
├── 08_SHapley_Additive_exPlanations.Rmd
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
    └── OS_borders
        ├── district_borough_unitary_region.dbf
        ├── district_borough_unitary_region.prj
        ├── district_borough_unitary_region.shp
        └── district_borough_unitary_region.shx
```
