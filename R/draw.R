drawDependencies <- function() {
  list(
    # // "leaflet-draw": "1.0.2",
    # // "leaflet-draw-drag": "1.0.2",
    # draw bindings
    html_dep_prod("lfx-draw", "1.0.2", has_style = TRUE, has_binding = TRUE),
    html_dep_prod("lfx-draw-drag", "1.0.2")
  )
}

#' Adds a Toolbar to draw shapes/points on the map.
#' @param map The map widget.
#' @param targetLayerId An optional layerId of a GeoJSON/TopoJSON layer whose features need to be editable.
#'  Used for adding  a GeoJSON/TopoJSON layer and then editing the features using the draw plugin.
#' @param targetGroup An optional group name of a Feature Group whose features need to be editable.
#'  Used for adding shapes(markers, lines, polygons) and then editing them using the draw plugin.
#'  You can either set layerId or group or none but not both.
#' @param position The position where the toolbar should appear.
#' @param polylineOptions See \code{\link{drawPolylineOptions}}(). Set to FALSE to disable polyline drawing.
#' @param polygonOptions See \code{\link{drawPolygonOptions}}(). Set to FALSE to disable polygon drawing.
#' @param circleOptions See \code{\link{drawCircleOptions}}(). Set to FALSE to disable circle drawing.
#' @param rectangleOptions See \code{\link{drawRectangleOptions}}(). Set to FALSE to disable rectangle drawing.
#' @param markerOptions See \code{\link{drawMarkerOptions}}(). Set to FALSE to disable marker drawing.
#' @param circleMarkerOptions See \code{\link{drawCircleMarkerOptions}}(). Set to FALSE to disable circle marker drawing.
#' @param editOptions By default editing is disable. To enable editing pass \code{\link{editToolbarOptions}}().
#' @param singleFeature When set to TRUE, only one feature can be drawn at a time, the previous ones being removed.
#' @param toolbar See \code{\link{toolbarOptions}}. Set to \code{NULL} to take Leaflets default values.
#' @param handlers See \code{\link{handlersOptions}}. Set to \code{NULL} to take Leaflets default values.
#' @export
#' @rdname draw
#' @examples
#' leaflet() %>%
#'   setView(0, 0, 2) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addDrawToolbar(
#'     targetGroup = "draw",
#'     editOptions = editToolbarOptions(
#'       selectedPathOptions = selectedPathOptions()
#'     )
#'   ) %>%
#'   addLayersControl(
#'     overlayGroups = c("draw"),
#'     options = layersControlOptions(collapsed = FALSE)
#'   ) %>%
#'   addStyleEditor()
#'
#' ## for more examples see
#' # browseURL(system.file("examples/draw.R", package = "leaflet.extras"))
addDrawToolbar <- function(
    map, targetLayerId = NULL, targetGroup = NULL,
    position = c("topleft", "topright", "bottomleft", "bottomright"),
    polylineOptions = drawPolylineOptions(),
    polygonOptions = drawPolygonOptions(),
    circleOptions = drawCircleOptions(),
    rectangleOptions = drawRectangleOptions(),
    markerOptions = drawMarkerOptions(),
    circleMarkerOptions = drawCircleMarkerOptions(),
    editOptions = FALSE,
    singleFeature = FALSE,
    toolbar = NULL,
    handlers = NULL) {
  if (!is.null(targetGroup) && !is.null(targetLayerId)) {
    stop("To edit existing features either specify a targetGroup or a targetLayerId, but not both")
  }

  if (!inherits(toolbar, "list")) toolbar <- NULL
  if (!inherits(handlers, "list")) handlers <- NULL

  map$dependencies <- c(map$dependencies, drawDependencies())

  markerIconFunction <- NULL
  if (inherits(markerOptions, "list") && !is.null(markerOptions$markerIcon)) {
    if (inherits(markerOptions$markerIcon, "leaflet_icon")) {
      markerIconFunction <- defIconFunction
    } else if (inherits(markerOptions$markerIcon, "leaflet_awesome_icon")) {
      map <- addAwesomeMarkersDependencies(
        map, markerOptions$markerIcon$library
      )
      markerIconFunction <- awesomeIconFunction
    } else {
      stop("markerIcon should be created using either leaflet::makeIcon() or leaflet::makeAwesomeIcon()")
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
      circlemarker = circleMarkerOptions,
      singleFeature = singleFeature
    )),
    edit = editOptions,
    toolbar = toolbar,
    handlers = handlers
  )

  leaflet::invokeMethod(
    map, leaflet::getMapData(map), "addDrawToolbar",
    targetLayerId, targetGroup, options
  )
}

#' Removes the draw toolbar
#' @param clearFeatures whether to clear the map of drawn features.
#' @rdname draw
#' @export
removeDrawToolbar <- function(map, clearFeatures = FALSE) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), "removeDrawToolbar", clearFeatures)
}
