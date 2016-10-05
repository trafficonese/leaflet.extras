
# Source https://github.com/ursudio/webgl-heatmap-leaflet
webGLHeatmapDependency <- function() {
  list(
    htmltools::htmlDependency(
      "webgl-heatmap",version = "0.1.0",
      system.file("htmlwidgets/lib/webgl-heatmap", package = "leaflet.extras"),
      script = c("webgl-heatmap.js", "webgl-heatmap-leaflet.js", "webgl-heatmap-bindings.js")
    )
  )
}

#' Add a webgl heatmap
#' @param map the map to add pulse Markers to.
#' @param lng a numeric vector of longitudes, or a one-sided formula of the form
#'   \code{~x} where \code{x} is a variable in \code{data}; by default (if not
#'   explicitly provided), it will be automatically inferred from \code{data} by
#'   looking for a column named \code{lng}, \code{long}, or \code{longitude}
#'   (case-insensitively)
#' @param lat a vector of latitudes or a formula (similar to the \code{lng}
#'   argument; the names \code{lat} and \code{latitude} are used when guessing
#'   the latitude column from \code{data})
#' @param intensity intensity of the heat. A vector of numeric values or a formula.
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{\link{clearGroup}} and \code{\link{addLayersControl}} purposes).
#'   Human-friendly group names are permitted--they need not be short,
#'   identifier-style names. Any number of layers and even different types of
#'   layers (e.g. markers and polygons) can share the same group name.
#' @param size in meters or pixels
#' @param units either 'm' or 'px'
#' @param opacity for the canvas element
#' @param gradientTexture image url or image
#' @param alphaRange adjust transparency by changing to value between 0 and 1
#' @param data the data object from which the argument values are derived; by
#'   default, it is the \code{data} object provided to \code{leaflet()}
#'   initially, but can be overridden
#' @rdname heatmap
#' @export
addWebGLHeatmap = function(
  map, lng = NULL, lat = NULL, intensity = NULL, layerId = NULL, group = NULL,
  size = '30000',
  units = 'm',
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1,
  data = leaflet::getMapData(map)
) {
  map$dependencies <- c(map$dependencies,
                        webGLHeatmapDependency())

  pts = leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addWebGLHeatmap")
  leaflet::invokeMethod(
    map, data, 'addWebGLHeatmap', pts$lat, pts$lng, intensity,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    ))
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}

#' removes the webgl heatmap
#' @rdname heatmap
#' @export
removeWebGLHeatmap = function(map, layerId) {
    leaflet::invokeMethod(map, leaflet::getMapData(map), 'removeWebGLHeatmap', layerId)
}

#' clears the webgl heatmap
#' @rdname heatmap
#' @export
clearWebGLHeatmap = function(map) {
    leaflet::invokeMethod(map, NULL, 'clearWebGLHeatmap')
}
