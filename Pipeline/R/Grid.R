load_vector <- function(path, crs) {
  st_read(path, quiet = TRUE) %>%
    st_transform(crs = crs)
}

build_dtm <- function(zip_paths, boundary, city_label,
                      exdir = "dtm_tiles/_shared_unzipped",
                      out_path = file.path("dtm_tiles", paste0("dtm_", city_label, ".tif"))) {
  if (!dir.exists(exdir)) dir.create(exdir, recursive = TRUE)
  for (z in zip_paths) {
    if (!file.exists(file.path(exdir, basename(z)))) {
      unzip(z, exdir = exdir, overwrite = FALSE)
    }
  }
  dtm <- vrt(list.files(exdir, pattern = "\\.tif$", full.names = TRUE))
  dtm <- crop(dtm, vect(boundary))
  terra::writeRaster(dtm, out_path, overwrite = TRUE)
  out_path
}

make_grid <- function(boundary, cellsize = 1000) {
  st_make_grid(boundary, cellsize = cellsize, square = TRUE) %>%
    st_sf() %>%
    st_filter(boundary, .predicate = st_intersects) %>%
    mutate(cell_id = row_number())
}

add_elevation <- function(grid, dtm_path, fact = 50) {
  dtm <- terra::rast(dtm_path)   
  dtm_agg <- terra::aggregate(dtm, fact = fact, fun = mean, na.rm = TRUE)
  elev <- terra::extract(dtm_agg, vect(grid), fun = mean, na.rm = TRUE)
  grid$dtm_elev <- elev[,2]
  grid$dtm_elev[is.nan(grid$dtm_elev)] <- NA
  grid
}

add_dominant_risk <- function(grid_sf, hazard_sf, risk_col, levels) {
  
  dom <- st_intersection(
    grid_sf %>% dplyr::select(cell_id),
    hazard_sf %>% dplyr::select(risk_band)
  ) %>%
    dplyr::mutate(overlap_area = st_area(.)) %>%
    st_drop_geometry() %>%
    dplyr::mutate(risk_band = factor(risk_band, levels = levels, ordered = FALSE)) %>%
    dplyr::group_by(cell_id, risk_band) %>%
    dplyr::summarise(
      overlap_area = sum(overlap_area),
      .groups = "drop"
    ) %>%
    dplyr::group_by(cell_id) %>%
    dplyr::arrange(dplyr::desc(overlap_area), dplyr::desc(risk_band), .by_group = TRUE) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup() %>%
    dplyr::select(cell_id, !!risk_col := risk_band)
  
  dplyr::left_join(grid_sf, dom, by = "cell_id")
}

add_flood_risk <- function(grid_sf, rofsw, rofrs) {
  grid_sf <- add_dominant_risk(
    grid_sf, rofsw, "rofsw_risk",
    levels = c("Low", "Medium", "High")
  )
  add_dominant_risk(
    grid_sf, rofrs, "rofrs_risk",
    levels = c("Very low", "Low", "Medium", "High")
  )
}

load_within_boundary <- function(path, crs, boundary) {
  st_read(path, quiet = TRUE) %>%
    st_transform(crs = crs) %>%
    filter(st_intersects(geometry, boundary, sparse = FALSE)[, 1])
}

add_forest <- function(grid, forest) {
  forest_summary <- st_join(grid, forest, join = st_intersects) %>%
    st_drop_geometry() %>%
    group_by(cell_id) %>%
    summarise( avg_area_ha = mean(Area_Ha, na.rm = TRUE),forest_types = paste(unique(IFT_IOA[!is.na(IFT_IOA)]), collapse = ", ")) %>%
    mutate(avg_area_ha = ifelse(is.nan(avg_area_ha), 0, avg_area_ha),forest_types = ifelse(forest_types == "", NA, forest_types))
  grid %>% left_join(forest_summary, by = "cell_id")
}

add_trees <- function(grid, trees) {
  tree_summary <- st_join(grid, trees, join = st_intersects) %>%
    st_drop_geometry() %>% 
    group_by(cell_id) %>%
    summarise(treeht = mean(meanht, na.rm = TRUE),tree_type = paste(unique(woodland_t[!is.na(woodland_t)]), collapse = ", ")) %>%
    mutate(treeht = ifelse(is.nan(treeht), 0, treeht),tree_type = ifelse(tree_type == "", NA, tree_type))
  
  grid %>% left_join(tree_summary, by = "cell_id")
}

load_intersecting <- function(path, crs, boundary) {
  st_read(path, quiet = TRUE) %>%
    st_transform(crs = crs) %>%
    filter(lengths(st_intersects(., boundary)) > 0)
}

add_weighted_climate <- function(grid, layer, value_col, out_col) {
  intersected <- st_intersection(grid, layer) %>%
    mutate(intersect_area = st_area(.))
  
  summary_tbl <- intersected %>%
    st_drop_geometry() %>%
    group_by(cell_id) %>%
    summarise(weighted_value = weighted.mean(.data[[value_col]], as.numeric(intersect_area), na.rm = TRUE))
  
  names(summary_tbl)[names(summary_tbl) == "weighted_value"] <- out_col
  grid %>% left_join(summary_tbl, by = "cell_id")
}

build_imperviousness <- function(zip_paths, boundary, city_label,
                                 exdir = "imperv_tiles/_shared_unzipped",
                                 out_path = file.path("imperv_tiles", paste0("imperv_", city_label, ".tif"))) {
  if (!dir.exists(exdir)) dir.create(exdir, recursive = TRUE)
  for (z in zip_paths) {
    if (!file.exists(file.path(exdir, basename(z)))) {
      unzip(z, exdir = exdir, overwrite = FALSE)}}
  
  tif_files <- list.files(exdir, pattern = "\\.tif$", full.names = TRUE, 
                          recursive = TRUE, ignore.case = TRUE)

  imperv <- vrt(tif_files)
  
  boundary_native <- sf::st_transform(boundary, terra::crs(imperv))
  imperv <- crop(imperv, vect(boundary_native))
  
  terra::writeRaster(imperv, out_path, overwrite = TRUE)
  out_path
}

add_imperviousness <- function(grid, imperv_path, crs, fact = 50) {
  imperv <- terra::rast(imperv_path)
  imperv_agg <- terra::aggregate(imperv, fact = fact, fun = "mean", na.rm = TRUE)
  imperv_agg <- terra::project(imperv_agg, paste0("epsg:", crs))
  
  imperv_summary <- terra::extract(imperv_agg, terra::vect(grid), fun = mean, na.rm = TRUE)
  grid %>% mutate(avg_imperv = imperv_summary[, 2])
}

add_river_distance <- function(grid, rivers) {
  centroids <- sf::st_centroid(grid)
  nearest_idx <- sf::st_nearest_feature(centroids, rivers)
  dist <- sf::st_distance(centroids, rivers[nearest_idx, ], by_element = TRUE)
  grid$dist_to_river <- as.numeric(dist)
  grid
}

add_greenspace <- function(grid, greenspace) {
  greenspace_summary <- st_intersection(grid, greenspace) %>%
    mutate(overlap_area = as.numeric(st_area(.))) %>%
    st_drop_geometry() %>%
    group_by(cell_id) %>%
    summarise(
      greenspace_area = sum(overlap_area, na.rm = TRUE),
      greenspace_types = paste(unique(`function.`[!is.na(`function.`)]), collapse = ", ")
    )
  
  grid %>%
    left_join(greenspace_summary, by = "cell_id") %>%
    mutate(
      cell_area = as.numeric(st_area(geometry)),
      pct_greenspace = ifelse(is.na(greenspace_area), 0, greenspace_area / cell_area),
      greenspace_types = ifelse(greenspace_types == "" | is.na(greenspace_types), NA, greenspace_types)
    ) %>%
    dplyr::select(-greenspace_area, -cell_area)
}

save_gpkg <- function(grid, path, layer = "grid") {
  st_write(grid, path, layer = layer, delete_dsn = TRUE, quiet = TRUE)
  path
}