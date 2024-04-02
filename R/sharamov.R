bingLayerDependencies <- function() {
  list(
    # // "leaflet-plugins": "3.0.2",
    html_dep_prod("tile-bing", "3.0.2", has_binding = TRUE)
  )
}

#' Adds Bing Tiles Layer
#'
#' @param map The Map widget
#' @param apikey String. Bing API Key
#' @param imagerySet String. Type of Tiles to display
#' @param layerId String. An optional unique ID for the layer
#' @param group String. An optional group name for the layer
#' @param ... Optional Parameters required by the Bing API described at \url{https://msdn.microsoft.com/en-us/library/ff701716.aspx}
#' @seealso Get a Bing Maps API Key: \url{https://msdn.microsoft.com/en-us/library/ff428642.aspx}
#' @export
addBingTiles <- function(
    map,
    apikey = Sys.getenv("BING_MAPS_API_KEY"),
    imagerySet = c(
      "Aerial", "AerialWithLabels",
      "AerialWithLabelsOnDemand", "AerialWithLabelsOnDemand",
      "Birdseye", "BirdseyeWithLabels", "BirdseyeV2", "BirdseyeV2WithLabels",
      "CanvasDark", "CanvasLight", "CanvasGray",
      "Road", "RoadOnDemand", "Streetside"
    ),
    layerId = NULL,
    group = NULL,
    ...) {
  if (is.null(apikey) || apikey == "") {
    stop("Bing Tile Layer requires an apikey")
  }

  imagerySet <- match.arg(imagerySet)
  if (imagerySet == "AerialWithLabels") {
    warning(
      "AerialWithLabels is Deprecated! Aerial imagery with a road overlay, using the legacy static tile service.\n",
      "This service is deprecated and current data will not be refreshed.\n",
      "New applications should instead use 'AerialWithLabelsOnDemand'."
    )
  }
  if (imagerySet == "Road") {
    warning(
      "Road is Deprecated! Roads without additional imagery, using the legacy static tile service.\n",
      "This service is deprecated and current data will not be refreshed. \n",
      "New applications should instead use 'RoadOnDemand'."
    )
  }

  map$dependencies <- c(map$dependencies, bingLayerDependencies())
  invokeMethod(
    map, getMapData(map), "addBingTiles", layerId, group,
    list(apikey = apikey, type = imagerySet, ...)
  )
}
