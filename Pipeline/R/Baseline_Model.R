fit_richness <- function(grid_model){
  list(
    null = glm.nb(sp_richness ~ 1, data = grid_model),
    full = glm.nb(sp_richness ~ n_days +
                    dtm_elev + 
                    avg_imperv +
                    rofsw_risk + 
                    rofrs_risk + 
                    avg_area_ha + 
                    treeht +
                    weighted_precip + 
                    weighted_temp + 
                    dist_to_river +
                    pct_greenspace,
                  data = grid_model)
  )
}

fit_shannon <- function(grid_model){
  list(
    null = glm(shannon ~1, data = grid_model),
    full = glm(shannon ~ n_days +
                 dtm_elev + 
                 avg_imperv +
                 rofsw_risk + 
                 rofrs_risk + 
                 avg_area_ha + 
                 treeht +
                 weighted_precip + 
                 weighted_temp + 
                 dist_to_river +
                 pct_greenspace,
               family = Gamma(link = "log"),
               data = grid_model)
    )
}

fit_simpson <- function(grid_model){
  n <- nrow(grid_model)
  simpson_adj <- (grid_model$simpson * (n - 1) + 0.5) / n
  grid_model$simpson_adj <- simpson_adj
  
  list(
    null = betareg(simpson_adj ~ 1, data = grid_model),
    full = betareg(simpson_adj ~ n_days + 
                     dtm_elev + 
                     avg_imperv +
                     rofsw_risk + 
                     rofrs_risk + 
                     avg_area_ha + 
                     treeht +
                     weighted_precip + 
                     weighted_temp + 
                     dist_to_river +
                     pct_greenspace,
                   data = grid_model)
  )
}