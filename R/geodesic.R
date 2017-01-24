geodesicDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "geodesic",version = "0.1.0",
      system.file("htmlwidgets/lib/geodesic", package = "leaflet.extras"),
      script = c('Leaflet.Geodesic.min.js', 'geodesic-bindings.js')
    )
  )
}

#' Add Geodesic Lines
#' @param map map object
#' @param lat vector of latitudes
#' @param lng vector of longitudes
#' @param layerId the layer id
#' @param group the name of the group this raster image should belong to (see
#' @param steps Defines how many intermediate points are generated along the path. More steps mean a smoother path.
#' @param wrap Wrap line at map border (date line). Set to 'false' if you want lines to cross the dateline (experimental, see noWrap-example on how to use)
#' @param stroke whether to draw stroke along the path (e.g. the borders of
#'   polygons or circles)
#' @param color stroke color
#' @param weight stroke width in pixels
#' @param opacity stroke opacity (or layer opacity for tile layers)
#' @param dashArray a string that defines the stroke
#'   \href{https://developer.mozilla.org/en/SVG/Attribute/stroke-dasharray}{dash  pattern}
#' @param smoothFactor how much to simplify the polyline on each zoom level
#' @param noClip whether to disable polyline clipping
#'   (more means better performance and less accurate representation)
#' @param popup a character vector of the HTML content for the popups (you are
#'   recommended to escape the text using \code{\link[htmltools]{htmlEscape}()}
#' @param popupOptions A Vector of \code{\link{popupOptions}} to provide popups
#'   for security reasons)
#' @param label a character vector of the HTML content for the labels
#' @param labelOptions A Vector of \code{\link{labelOptions}} to provide label
#' options for each label. Default \code{NULL}
#' @param options a list of additional options, intended to be provided by
#'   a call to \code{\link[leaflet]{pathOptions}}()
#' @param highlightOptions Options for highlighting the shape on mouse over.
#' @param data map data
#' @export
addGeodesicPolylines = function(
  map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
  steps = 10,
  wrap = TRUE,
  stroke = TRUE,
  color = "#03F",
  weight = 5,
  opacity = 0.5,
  dashArray = NULL,
  smoothFactor = 1.0,
  noClip = FALSE,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = pathOptions(),
  highlightOptions = NULL,
  data = getMapData(map)
) {
  map$dependencies <- c(map$dependencies, geodesicDependencies())

  options = c(options, list(
    steps = steps, wrap = wrap,
    stroke = stroke, color = color, weight = weight, opacity = opacity,
    dashArray = dashArray, smoothFactor = smoothFactor, noClip = noClip
  ))
  pgons = leaflet::derivePolygons(
    data, lng, lat, missing(lng), missing(lat), "addGeodesicPolylines")
  leaflet::invokeMethod(
    map, data, 'addGeodesicPolylines', pgons, layerId, group, options,
    popup, popupOptions, safeLabel(label, data), labelOptions, highlightOptions) %>%
    leaflet::expandLimitsBbox(pgons)
}


#' @export
#' @describeIn addGeodesicPolylines Adds a Great Circle to the map
#' @param lat_center,lng_center lat/lng for the center
#' @param radius in meters
addGreatCircles = function(
  map, lat_center = NULL, lng_center = NULL, radius, layerId = NULL, group = NULL,
  steps = 10,
  wrap = TRUE,
  stroke = TRUE,
  color = "#03F",
  weight = 5,
  opacity = 0.5,
  dashArray = NULL,
  smoothFactor = 1.0,
  noClip = FALSE,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = pathOptions(),
  highlightOptions = NULL,
  data = getMapData(map)
) {
  map$dependencies <- c(map$dependencies, geodesicDependencies())

  options = c(options, list(
    steps = steps, wrap = wrap,
    stroke = stroke, color = color, weight = weight, opacity = opacity,
    dashArray = dashArray, smoothFactor = smoothFactor, noClip = noClip
  ))
  points = leaflet::derivePoints(
    data, lng_center, lat_center, missing(lng_center), missing(lat_center),
    "addGreatCircles")
  leaflet::invokeMethod(
    map, data, 'addGreatCircles',  points$lat, points$lng, radius, layerId, group, options,
    popup, popupOptions, safeLabel(label, data), labelOptions, highlightOptions) %>%
    leaflet::expandLimits(points$lat, points$lng)
}
