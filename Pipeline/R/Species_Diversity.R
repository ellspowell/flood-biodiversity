load_species <- function(path, crs, boundary) {
  read.csv(path) %>%
    st_as_sf(coords = c("Longitude..WGS84.", "Latitude..WGS84."), crs = 4326) %>%
    st_transform(crs = crs) %>%
    filter(st_within(geometry, boundary, sparse = FALSE)[,1])
}

join_species_to_grid <- function(species_sf, grid) {
  st_join(species_sf, grid, join = st_intersects)
}

build_incidence <- function(speciesgrid, min_cells = 3) {
  incidence <- speciesgrid %>%
    st_drop_geometry() %>%
    filter(!((is.na(Scientific.name) | Scientific.name == "") & (is.na(Common.name) | Common.name == ""))) %>%
    distinct(cell_id, Scientific.name) %>%
    mutate(present = 1) %>%
    pivot_wider(names_from = Scientific.name, values_from = present, values_fill = 0) %>%
    arrange(cell_id)
  
  cell_counts <- colSums(incidence %>% dplyr::select(-cell_id))
  incidence %>% dplyr::select(cell_id, names(cell_counts[cell_counts > min_cells]))
}

calc_richness <- function(incidence_filtered) {
  incidence_filtered %>%
    mutate(sp_richness = rowSums(dplyr::select(., - cell_id))) %>%
    dplyr::select(cell_id, sp_richness)
}

build_abundance <- function(speciesgrid, incidence_filtered) {
  keep_species <- names(incidence_filtered %>% dplyr::select(-cell_id))
  
  speciesgrid %>%
    st_drop_geometry() %>%
    filter(!((is.na(Scientific.name) | Scientific.name == "") & (is.na(Common.name) | Common.name == ""))) %>%
    mutate(Individual.count = replace_na(Individual.count, 1)) %>%
    group_by(cell_id, Scientific.name) %>%
    summarise(Individual.count = sum(Individual.count), .groups = "drop") %>%
    pivot_wider(names_from = Scientific.name, values_from = Individual.count, values_fill = 0) %>%
    arrange(cell_id) %>%
    dplyr::select(cell_id, all_of(keep_species))
}

calc_diversity <- function(abundance_filtered) {
  abund_matrix <- abundance_filtered %>% dplyr::select(-cell_id) %>% as.matrix()
  rownames(abund_matrix) <- abundance_filtered$cell_id
  
  tibble(cell_id = abundance_filtered$cell_id,
         shannon = diversity(abund_matrix, index = "shannon"),
         simpson = diversity(abund_matrix, index = "simpson")
         ) %>%
    dplyr::filter(!is.na(shannon))
}

calculate_effort <- function(records) {
  records %>%
    sf::st_drop_geometry() %>%
    dplyr::filter(!((is.na(Scientific.name) | Scientific.name == "") &
                      (is.na(Common.name) | Common.name == ""))) %>%
    dplyr::group_by(cell_id) %>%
    dplyr::summarise(
      n_records   = dplyr::n(),
      n_days      = dplyr::n_distinct(Event.Date),
      n_providers = dplyr::n_distinct(Data.provider),
      .groups = "drop")
}

add_diversity <- function(grid, diversity_results, richness) {
  grid %>%
    left_join(diversity_results, by = "cell_id") %>%
    left_join(richness, by = "cell_id")
}

add_effort <- function(grid_model, effort) {
  grid_model %>%
    dplyr::left_join(effort, by = "cell_id") %>%
    dplyr::mutate(
      n_records   = tidyr::replace_na(n_records, 0),
      n_days      = tidyr::replace_na(n_days, 0),
      n_providers = tidyr::replace_na(n_providers, 0),
      rofsw_risk  = relevel(factor(rofsw_risk, levels = c("Low", "Medium", "High"), ordered = FALSE), ref = "Low"),
      rofrs_risk  = relevel(factor(rofrs_risk, levels = c("Very low", "Low", "Medium", "High"), ordered = FALSE), ref = "Very low")) %>%
    dplyr::filter(n_days > 0)
}

save_gpkg <- function(grid, path, layer = "grid") {
  st_write(grid, path, layer = layer, delete_dsn = TRUE, quiet = TRUE)
  path
}
