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

#' adds a Toolbar to draw shapes/points on the map
#' @param map the map
#' @param layerId An optional unique ID for the layer that will hold the drawn shapes
#' @param group An optional group to which the layer that will hold the drawn shapes will be added.
#' @param position The position where the toolbar should appear.
#' @param polylineOptions See \code{\link{drawPolylineOptions}}(). Set to FALSE to disable polyline drawing.
#' @param polygonOptions See \code{\link{drawPolygonOptions}}(). Set to FALSE to disable polygon drawing.
#' @param circleOptions See \code{\link{drawCircleOptions}}(). Set to FALSE to disable circle drawing.
#' @param rectangleOptions See \code{\link{drawRectangeOptions}}(). Set to FALSE to disable rectangle drawing.
#' @param markerOptions See \code{\link{drawMarkerOptions}}(). Set to FALSE to disable marker drawing.
#' @param editOptions By default editing is disable. To enable editing pass \code{\link{editToolbarOptions}}().
#' @export
#' @rdname draw
addDrawToolbar <- function(
  map, layerId = NULL, group = NULL,
  position = c('topleft','topright','bottomleft','bottomright'),
  polylineOptions = drawPolylineOptions(),
  polygonOptions = drawPolygonOptions(),
  circleOptions = drawCircleOptions(),
  rectangleOptions = drawRectangeOptions(),
  markerOptions = drawMarkerOptions(),
  editOptions = FALSE
) {
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
      marker = markerOptions )),
    edit = editOptions )

  leaflet::invokeMethod(map, leaflet::getMapData(map), "addDrawToolbar",
                        layerId, group, options)
}

#' Removes the draw toolbar
#' @rdname draw
#' @export
removeDrawToolbar <- function(map) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), 'removeDrawToolbar')
}
