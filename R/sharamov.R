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
  imagerySet = c("Aerial", "AerialWithLabels",
                 "CanvasDark", "CanvasLight", "CanvasGray","AerialWithLabelsOnDemand","BirdseyeV2WithLabels",
                 "Road"),
  layerId = NULL,
  group = NULL,
  ...
  ) {

  if (is.null(apikey))
    stop("Bing Tile Layer requires an apikey")

  imagerySet <- match.arg(imagerySet)

  map$dependencies <- c(map$dependencies, bingLayerDependencies())
  invokeMethod(map, getMapData(map), "addBingTiles", layerId, group,
               list(apikey = apikey, type = imagerySet, ...))
}
