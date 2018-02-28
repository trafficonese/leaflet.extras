
# Source https://github.com/ursudio/webgl-heatmap-leaflet
webGLHeatmapDependency <- function() {
  list(
    htmltools::htmlDependency(
      "webgl-heatmap",version = "0.1.0",
      system.file("htmlwidgets/lib/webgl-heatmap", package = "leaflet.extras"),
      script = c("webgl-heatmap.js", "webgl-heatmap-leaflet.js",
                 "webgl-heatmap-bindings.js"),
      attachment = c("skyline" = "skyline-gradient.png",
                     "deep-sea" = "deep-sea-gradient.png",
                     # new colour gradients generated from http://patorjk.com/gradient-image-generator/
                     "green"  = "green.png",
                     "orange" = "orange.png",
                     "red"    = "red.png",
                     "rose"   = "rose.png",
                     "yellow" = "yellow.png")
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
#' @param gradientTexture Alternative colors for heatmap.
#'    allowed values are "skyline", "deep-sea"
#' @param alphaRange adjust transparency by changing to value between 0 and 1
#' @param data the data object from which the argument values are derived; by
#'   default, it is the \code{data} object provided to \code{leaflet()}
#'   initially, but can be overridden
#' @rdname webglheatmap
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

  if(!is.null(gradientTexture) &&
     !gradientTexture %in% c("skyline", "deep-sea", "rose", "green", "orange", "red", "yellow")) {
    stop("Only allowed values for gradientTexture are 'skyline', 'deep-sea', 'green', 'orange', 'red', 'rose' and 'yellow'")
  }

  pts = leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addWebGLHeatmap")

  if(is.null(intensity)) {
    points <- cbind(pts$lat, pts$lng)
  } else {
    if(inherits(intensity,'formula')) {
      intensity <- eval(intensity[[2]], data, environment(intensity))
    }
    points <- cbind(pts$lat, pts$lng, intensity)
  }

  leaflet::invokeMethod(
    map, data, 'addWebGLHeatmap', points,
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

#' Adds a heatmap with data from a GeoJSON/TopoJSON file/url
#' @param geojson The geojson or topojson url or contents as string.
#' @param intensityProperty The property to use for determining the intensity at a point.
#' Can be a 'string' or a JS function, or NULL.
#' @rdname webglheatmap
#' @export
addWebGLGeoJSONHeatmap = function(
  map, geojson, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = '30000',
  units = 'm',
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
  ) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    'addWebGLGeoJSONHeatmap', geojson, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    )))
}

#' Adds a heatmap with data from a KML file/url
#' @param kml The KML url or contents as string.
#' @rdname webglheatmap
#' @export
addWebGLKMLHeatmap = function(
  map, kml, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = '30000',
  units = 'm',
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
  ) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    'addWebGLKMLHeatmap', kml, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    )))
}

#' Adds a heatmap with data from a CSV file/url
#' @param csv The CSV url or contents as string.
#' @param csvParserOptions options for parsing the CSV.
#' Use \code{\link{csvParserOptions}}() to supply csv parser options.
#' @rdname webglheatmap
#' @export
addWebGLCSVHeatmap = function(
  map, csv, csvParserOptions, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = '30000',
  units = 'm',
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
  ) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    'addWebGLCSVHeatmap', csv, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    )),
    csvParserOptions)
}

#' Adds a heatmap with data from a GPX file/url
#' @param gpx The GPX url or contents as string.
#' @rdname webglheatmap
#' @export
addWebGLGPXHeatmap = function(
  map, gpx, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = '30000',
  units = 'm',
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
  ) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    'addWebGLGPXHeatmap', gpx, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    )))
}


#' removes the webgl heatmap
#' @rdname webglheatmap
#' @export
removeWebGLHeatmap = function(map, layerId) {
    leaflet::invokeMethod(map, leaflet::getMapData(map), 'removeWebGLHeatmap', layerId)
}

#' clears the webgl heatmap
#' @rdname webglheatmap
#' @export
clearWebGLHeatmap = function(map) {
    leaflet::invokeMethod(map, NULL, 'clearWebGLHeatmap')
}
