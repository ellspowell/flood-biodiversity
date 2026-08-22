library(targets)
library(tarchetypes)

tar_option_set(packages = c("readr", "sf", "dplyr", "terra", "tidyr", "tidyverse", "vegan", "ggplot2", "MASS", "betareg", "ranger"))
tar_source()
project_crs <- 27700

#Set up cities table
cities <- tibble::tibble(
  city_name  = c("City of Bristol (B)", "Gateshead District (B)", "Newcastle upon Tyne District (B)",
                 "Exeter District (B)", "City of Nottingham (B)"),
  city_label = c("Bristol", "Gateshead", "Newcastle", "Exeter", "Nottingham"))

#Load shared targets 
shared_targets <- list(
  tar_target(boundary_file, "Data/OS_borders/district_borough_unitary_region.shp", format = "file"),
  tar_target(rofsw_file, "Data/rofsw_data/rofsw_data.shp", format = "file"),
  tar_target(rofrs_file, "Data/rofrs_data/rofrs_data_all.shp", format = "file"),
  tar_target(lidar_zips, {files <- list.files("Data/lidar", pattern = "\\.zip$", full.names = TRUE) if (length(files) == 0){stop("No LIDAR ZIP files found")} files}, format = "file"),
  tar_target(forest_file, "Data/National_Forest_Inventory_England_2023/National_Forest_Inventory_England_2023.shp", format = "file"),
  tar_target(trees_file, "Data/trees_outside_woodland_data/trees.shp", format = "file"),
  tar_target(precip_file, "Data/Annual_Precipitation_Observations_1991_2020/Annual_Precipitation_Observations_1991-2020.shp", format = "file"),
  tar_target(temp_file, "Data/Annual_Temperature_Observations_1991_2020/Annual_Temperature_Observations_1991-2020.shp", format = "file"),
  tar_target(imperv_zips, {files <- list.files("Data/Impervious_Density_UK_2024", pattern = "\\.zip$", full.names = TRUE) if (length(files)==0) {stop("No Impervious ZIP files found")} files}, format = "file"),
  tar_target(rivers_file, "Data/OS_rivers_gb/data/WatercourseLink.shp", format = "file"),
  tar_target(greenspace_file, "Data/OS_greenspace/GB_GreenspaceSite.shp", format = "file"),
  tar_target(species_file, "Data/Species_Data.csv", format = "file"))

#Build each city using the cities table
per_city_targets <- tar_map(
  values = cities,
  names = city_label,
  
  tar_target(study_boundary, load_vector(boundary_file, project_crs) %>%
               dplyr::filter(NAME == city_name) %>%
               sf::st_as_sf()),
  
  tar_target(rofsw, load_within_boundary(rofsw_file, project_crs, study_boundary)),
  tar_target(rofrs, load_within_boundary(rofrs_file, project_crs, study_boundary)),
  
  tar_target(dtm, build_dtm(lidar_zips, study_boundary, city_label), format = "file"), 
  tar_target(imperv, build_imperviousness(imperv_zips, study_boundary, city_label), format = "file"), 
  
  tar_target(grid_base, make_grid(study_boundary)),
  tar_target(grid_elev, add_elevation(grid_base, dtm)), 
  tar_target(grid_flood, add_flood_risk(grid_elev, rofsw, rofrs)), 
  
  tar_target(forest, load_within_boundary(forest_file, project_crs, study_boundary)),
  tar_target(grid_forest, add_forest(grid_flood, forest)),
  
  tar_target(trees, load_within_boundary(trees_file, project_crs, study_boundary)),
  tar_target(grid_trees, add_trees(grid_forest, trees)),
  
  tar_target(precip, load_intersecting(precip_file, project_crs, study_boundary)),
  tar_target(grid_precip, add_weighted_climate(grid_trees, precip, "pr", "weighted_precip")),
  
  tar_target(temp, load_intersecting(temp_file, project_crs, study_boundary)),
  tar_target(grid_temp, add_weighted_climate(grid_precip, temp, "tas", "weighted_temp")),
  
  tar_target(grid_imperv, add_imperviousness(grid_temp, imperv, project_crs)), 
  
  tar_target(rivers_boundary, sf::st_buffer(study_boundary, 5000)),
  tar_target(rivers, load_within_boundary(rivers_file, project_crs, rivers_boundary)),
  tar_target(grid_rivers, add_river_distance(grid_imperv, rivers)), 
  
  tar_target(greenspace, load_within_boundary(greenspace_file, project_crs, study_boundary)),
  tar_target(grid_final, add_greenspace(grid_rivers, greenspace)),
  
  tar_target(grid_gpkg, save_gpkg(grid_final, paste0("Data/grid_1km_", city_label, ".gpkg")), format = "file"),
  
  tar_target(species_sf, load_species(species_file, project_crs, study_boundary)),
  tar_target(speciesgrid, join_species_to_grid(species_sf, grid_final)),
  
  tar_target(effort, calculate_effort(speciesgrid)),
  
  tar_target(incidence_filtered, build_incidence(speciesgrid)),
  tar_target(richness, calc_richness(incidence_filtered)),
  
  tar_target(abundance_filtered, build_abundance(speciesgrid, incidence_filtered)),
  tar_target(diversity_results, calc_diversity(abundance_filtered)),
  
  tar_target(grid_model, add_diversity(grid_final, diversity_results, richness)),
  tar_target(grid_model_effort, add_effort(grid_model, effort) %>%
               dplyr::mutate(city = city_label, .before = 1)))

# Row-bind every city's grid_model_effort branch into a single sf object, then write it out as one combined gpkg for the modelling steps.

grid_model_combined <- tar_combine(
  grid_model_all,
  tarchetypes::tar_select_targets(per_city_targets, starts_with("grid_model_effort_")),
  command = dplyr::bind_rows(!!!.x))

grid_model_all_gpkg <- tar_target(
  grid_model_gpkg,
  save_gpkg(grid_model_all, "Data/grid_model.gpkg", layer = "grid_cells"),
  format = "file")

# Output list

list(
  shared_targets,
  per_city_targets,
  grid_model_combined,
  grid_model_all_gpkg,
  
  tar_target(richness_models, fit_richness(grid_model_all)),
  #tar_target(shannon_models, fit_shannon(grid_model_all)),
  tar_target(simpson_models, fit_simpson(grid_model_all)),
  
  tar_render(report, "pipeline_report.Rmd"))
