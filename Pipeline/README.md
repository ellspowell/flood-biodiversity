## How to run the pipeline

This guide outlines how to set up and run the pipeline.

### Step One
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
```

### Step Two
Download the raw data. 

```
CSCT_Pipeline/
├── _targets.R
├── pipeline_report.Rmd
└── R/
    ├── Grid.R
    ├── Species_Diversity.R
    └── Baseline_Model.R
└── Data/
    ├── 
    ├── 
    ├── 
    ├──
    ├── 
    ├── 
    ├── 
    ├──
    ├── 
    ├── 
    └── Baseline_Model.R
```

### Step Three
Install the required packages, using the code below:

```r
required_packages <- c("readr", "sf", "dplyr", "terra", "tidyr", "tidyverse", "vegan", "ggplot2", "MASS", "betareg", "ranger")

new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

if (length(new_packages) > 0) {install.packages(new_packages)}
```

### Step Four
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
