omnivoreDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "leaflet.extras-omnivore",version = "0.1.0",
      system.file("htmlwidgets/lib/omnivore", package = "leaflet.extras"),
      script = c("leaflet-omnivore.min.js", "omnivore-bindings.js")
    )
  )
}


#' Adds a GeoJSON to the leaflet map.
#' This is a feature rich alternative to the \code{\link[leaflet]{addGeoJSON}} with
#' options to map feature properties to labels, popups, colors, markers etc.
#' @param map the leaflet map widget
#' @param geojson a GeoJSON list, or character vector of length 1
#' @param layerId the layer id
#' @param group the name of the group this raster image should belong to (see
#'   the same parameter under \code{\link{addTiles}})
#' @param markerIconProperty The property of the feature to use for marker icon.
#' Can be a JS function which accepts a feature and returns an index of \code{markerIcons}.
#' In either case the result must be one of the indexes of markerIcons.
#' @param markerOptions The options for markers
#' @param markerIcons Icons for Marker.
#' Can be a single marker using \code{\link[leaflet]{makeIcon}}
#' or a list of markers using \code{\link[leaflet]{iconList}}
#' @param clusterOptions if not \code{NULL}, markers will be clustered using
#'   \href{https://github.com/Leaflet/Leaflet.markercluster}{Leaflet.markercluster};
#'    you can use \code{\link[leaflet]{markerClusterOptions}()} to specify marker cluster
#'   options
#' @param clusterId the id for the marker cluster layer
#' @param labelProperty The property to use for the label.
#' You can also pass in a JS function that takes in a feature and returns a text/HTML content.
#' @param labelOptions A Vector of \code{\link{labelOptions}} to provide label
#' @param popupProperty The property to use for popup content
#' You can also pass in a JS function that takes in a feature and returns a text/HTML content.
#' @param popupOptions A Vector of \code{\link{popupOptions}} to provide popups
#' @param stroke whether to draw stroke along the path (e.g. the borders of
#'   polygons or circles)
#' @param color stroke color
#' @param weight stroke width in pixels
#' @param opacity stroke opacity (or layer opacity for tile layers)
#' @param fill whether to fill the path with color (e.g. filling on polygons or
#'   circles)
#' @param fillColor fill color
#' @param fillOpacity fill opacity
#' @param dashArray a string that defines the stroke
#'   \href{https://developer.mozilla.org/en/SVG/Attribute/stroke-dasharray}{dash
#'   pattern}
#' @param smoothFactor how much to simplify the polyline on each zoom level
#'   (more means better performance and less accurate representation)
#' @param noClip whether to disable polyline clipping
#' @param pathOptions Options for shapes
#' @param highlightOptions Options for highlighting the shape on mouse over.
#' options for each label. Default \code{NULL}
#'    you can use \code{\link[leaflet]{highlightOptions}()} to specify highlight
#'   options
#' @rdname omnivore
#' @export
addGeoJSONv2 = function(
  map, geojson, layerId = NULL, group = NULL,
  markerIconProperty = NULL, markerOptions = leaflet::markerOptions(),
  markerIcons = NULL,
  clusterOptions = NULL, clusterId = NULL,
  labelProperty = NULL, labelOptions = leaflet::labelOptions(),
  popupProperty = NULL, popupOptions = leaflet::popupOptions(),
  stroke = TRUE,
  color = "#03F",
  weight = 5,
  opacity = 0.5,
  fill = TRUE,
  fillColor = color,
  fillOpacity = 0.2,
  dashArray = NULL,
  smoothFactor = 1.0,
  noClip = FALSE,
  pathOptions = leaflet::pathOptions(),
  highlightOptions = NULL
) {

  map$dependencies <- c(map$dependencies, omnivoreDependencies())

  if (!is.null(clusterOptions)) {
    map$dependencies = c(map$dependencies,
                         leaflet::leafletDependencies$markerCluster())
  }

  pathOptions = c(pathOptions, list(
    stroke = stroke, color = color, weight = weight, opacity = opacity,
    fill = fill, fillColor = fillColor, fillOpacity = fillOpacity,
    dashArray = dashArray, smoothFactor = smoothFactor, noClip = noClip))

  markerIconFunction <- NULL
  if(!is.null(markerIcons)) {
     if(inherits(markerIcons,'leaflet_icon_set') ||
        inherits(markerIcons, 'leaflet_icon')) {
       markerIconFunction <- defIconFunction
     } else if(inherits(markerIcons,'leaflet_awesome_icon_set') ||
               inherits(markerIcons, 'leaflet_awesome_icon')) {
       if(inherits(markerIcons,'leaflet_awesome_icon_set')) {
         libs <- unique(sapply(markerIcons,function(icon) icon$library))
         map <- addAwesomeMarkersDependencies(map,libs)
       } else {
         map <- addAwesomeMarkersDependencies(map,markerIcons$library)
       }
       markerIconFunction <- awesomeIconFunction
     } else {
       stop('markerIcons should be created using either leaflet::iconList() or leaflet::awesomeIconList()')
     }
  }

  invokeMethod(
    map, getMapData(map), 'addGeoJSONv2', geojson, layerId, group,
    markerIconProperty, markerOptions, markerIcons, markerIconFunction,
    clusterOptions, clusterId,
    labelProperty, labelOptions, popupProperty, popupOptions,
    pathOptions, highlightOptions)
}
