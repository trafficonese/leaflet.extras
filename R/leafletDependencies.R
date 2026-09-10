#' Add Bootstrap dependency to a map
#' @param map the map widget
#' @export
addBootstrapDependency <- function(map) {
  map$dependencies <- c(
    map$dependencies,
    leaflet::leafletDependencies$bootstrap()
  )
  map
}

#' Add AwesomeMarkers and related lib dependencies to a map
#' @param map the map widget
#' @param libs char vector with lib names.
#' @export
addAwesomeMarkersDependencies <- function(map, libs) {
  map$dependencies <- c(
    map$dependencies,
    leaflet::leafletDependencies$awesomeMarkers()
  )
  if ("fa" %in% libs) {
    map$dependencies <- c(
      map$dependencies,
      leaflet::leafletDependencies$fontawesome()
    )
  }
  if ("ion" %in% libs) {
    map$dependencies <- c(
      map$dependencies,
      leaflet::leafletDependencies$ionicon()
    )
  }
  if ("glyphicon" %in% libs) {
    map$dependencies <- c(
      map$dependencies,
      leaflet::leafletDependencies$bootstrap()
    )
  }
  map
}

#' Various leaflet dependency functions for use in downstream packages
#' @export
leafletExtrasDependencies <- list(
  omnivore = function() {
    omnivoreDependencies()
  },
  choropleth = function() {
    geoJSONChoroplethDependency()
  },
  weatherIcons = function() {
    weatherIconDependency()
  },
  pulseIcons = function() {
    pulseIconDependency()
  },
  webGLHeatmap = function() {
    webGLHeatmapDependency()
  }
)
