drawDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "draw",version = "0.1.0",
      system.file("htmlwidgets/lib/draw", package = "leaflet.extras"),
      script = c(
        'leaflet.draw-src.js',
        'Leaflet.draw.drag-src.js',
        'draw-bindings.js'),
      stylesheet = c('leaflet.draw.css')
    )
  )
}

#' Adds a Toolbar to draw shapes/points on the map.
#' @param map The map widget.
#' @param targetLayerId An optional layerId of a GeoJSON/TopoJSON layer whose features need to be editable.
#'  Used for adding  a GeoJSON/TopoJSON layer and then editing the features using the draw plugin.
#' @param targetGroup An optional group name of a Feature Group whose features need to be editable.
#'  Used for adding shapes(markers,lines,polygons) and then editing them using the draw plugin.
#'  You can either set layerId or group or none but not both.
#' @param position The position where the toolbar should appear.
#' @param polylineOptions See \code{\link{drawPolylineOptions}}(). Set to FALSE to disable polyline drawing.
#' @param polygonOptions See \code{\link{drawPolygonOptions}}(). Set to FALSE to disable polygon drawing.
#' @param circleOptions See \code{\link{drawCircleOptions}}(). Set to FALSE to disable circle drawing.
#' @param rectangleOptions See \code{\link{drawRectangleOptions}}(). Set to FALSE to disable rectangle drawing.
#' @param markerOptions See \code{\link{drawMarkerOptions}}(). Set to FALSE to disable marker drawing.
#' @param editOptions By default editing is disable. To enable editing pass \code{\link{editToolbarOptions}}().
#' @param singleFeature When set to TRUE, only one feature can be drawn at a time, the previous ones being removed.
#' @export
#' @rdname draw
addDrawToolbar <- function(
  map, targetLayerId = NULL, targetGroup = NULL,
  position = c('topleft','topright','bottomleft','bottomright'),
  polylineOptions = drawPolylineOptions(),
  polygonOptions = drawPolygonOptions(),
  circleOptions = drawCircleOptions(),
  rectangleOptions = drawRectangleOptions(),
  markerOptions = drawMarkerOptions(),
  editOptions = FALSE,
  singleFeature = FALSE
) {

  if(!is.null(targetGroup) && !is.null(targetLayerId)) {
      stop("To edit existing features either specify a targetGroup or a targetLayerId, but not both")
  }

  map$dependencies <- c(map$dependencies, drawDependencies())

  markerIconFunction <- NULL
  if(inherits(markerOptions, 'list') && !is.null(markerOptions$markerIcon)) {
     if(inherits(markerOptions$markerIcon, 'leaflet_icon')) {
       markerIconFunction <- defIconFunction
     } else if(inherits(markerOptions$markerIcon, 'leaflet_awesome_icon')) {
       map <- addAwesomeMarkersDependencies(
         map, markerOptions$markerIcon$library)
       markerIconFunction <- awesomeIconFunction
     } else {
       stop('markerIcon should be created using either leaflet::makeIcon() or leaflet::makeAwesomeIcon()')
     }
    markerOptions$markerIconFunction <- markerIconFunction
  }

  position <- match.arg(position)

  options <- list(
    position = position,
    draw = leaflet::filterNULL(list(
      polyline = polylineOptions,
      polygon = polygonOptions,
      circle = circleOptions,
      rectangle = rectangleOptions,
      marker = markerOptions,
      singleFeature = singleFeature)),
    edit = editOptions )

  leaflet::invokeMethod(map, leaflet::getMapData(map), "addDrawToolbar",
                        targetLayerId, targetGroup, options)
}

#' Removes the draw toolbar
#' @param clearFeatures whether to clear the map of drawn features.
#' @rdname draw
#' @export
removeDrawToolbar <- function(map, clearFeatures=FALSE) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), 'removeDrawToolbar', clearFeatures)
}
