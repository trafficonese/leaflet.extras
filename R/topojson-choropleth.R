# Source https://github.com/TrantorM/leaflet-choroplethTopoJSON
topoJSONChoroplethDependency <- function() {
  list(
    htmltools::htmlDependency(
      "topojson-choropleth",version = "0.1.0",
      system.file("htmlwidgets/lib/topojson-choropleth", package = "leaflet.extras"),
      script = c("choroplethTopoJSON.min.js","topojson-choropleth-bindings.js")
    )
  )
}

#' @param map The leaflet map
#' @param data Geojson or topojson data: either as a list or a string
#' @param layerId a unique ID for the layer
#' @param group the group this layer will be added to
#' @param valueProperty The property to use for coloring
#' @param popupProperty The property to use for popup content
#' @param popupOptions The Options for the popup
#' @param labelProperty The property to use for labelling.
#' @param labelOptions The Options for the label
#' @param scale The scale to use from chroma.js
#' @param steps number of breakes
#' @param mode q for quantile, e for equidistant, k for k-means
#' @param colors overrides scale with manual colors
#' @param stroke whether to draw stroke along the path (e.g. the borders of
#'   polygons or circles)
#' @param color stroke color
#' @param weight stroke width in pixels
#' @param opacity stroke opacity (or layer opacity for tile layers)
#'   circles)
#' @param fillOpacity fill opacity
#' @param dashArray a string that defines the stroke
#'   \href{https://developer.mozilla.org/en/SVG/Attribute/stroke-dasharray}{dash
#'   pattern}
#' @param smoothFactor how much to simplify the polyline on each zoom level
#'   (more means better performance and less accurate representation)
#' @param noClip whether to disable polyline clipping
#' @param highlightOptions Options for highlighting shapes on hover.
#' @rdname topojson-choropleth
#' @export
addTopoJSONChoropleth = function(
  map, data, layerId = NULL, group = NULL,
  valueProperty,
  labelProperty = NULL, labelOptions = leaflet::labelOptions(),
  popupProperty = NULL, popupOptions = leaflet::popupOptions(),
  scale = c('white','red'),
  steps =5,
  mode = 'q',
  colors = NULL,
  stroke = TRUE,
  color = "#03F",
  weight = 1,
  opacity = 0.5,
  fillOpacity = 0.2,
  dashArray = NULL,
  smoothFactor = 1.0,
  noClip = FALSE,
  highlightOptions = NULL
) {
  map$dependencies <- c(map$dependencies,
                        topoJSONChoroplethDependency())
  options = list(
    valueProperty=valueProperty,
    popupProperty=popupProperty,
    popupOptions=popupOptions,
    labelProperty=labelProperty,
    labelOptions=labelOptions,
    scale=scale,
    steps=steps,
    mode=mode,
    colors=colors,
    stroke=stroke,
    color=color,
    weight=weight,
    opacity=opacity,
    fillOpacity=fillOpacity,
    dashArray=dashArray,
    smoothFactor=smoothFactor,
    noClip=noClip,
    highlightOptions = highlightOptions
  )
  leaflet::invokeMethod(
    map, leaflet::getMapData(map), 'addTopoJSONChoropleth',
    data, layerId, group, options)
}

#' removes the topojson choropleth.
#' @rdname topojson-choropleth
#' @export
removeTopoJSONChoropleth = function(map, layerId) {
    leaflet::invokeMethod(map, leaflet::getMapData(map), 'removeTopoJSONChoropleth', layerId)
}

#' clears the topojson choropleth.
#' @rdname topojson-choropleth
#' @export
clearTopoJSONChoropleth = function(map) {
    leaflet::invokeMethod(map, NULL, 'clearTopoJSONChoropleth')
}
