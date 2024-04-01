leafletGPSDependencies <- function() {
  list(
    # // "leaflet-gps": "1.7.0",
    html_dep_prod("lfx-gps", "1.7.0", has_style = TRUE, has_binding = TRUE)
  )
}

#' Options for the GPS Control
#' @param position Position of the Control
#' @param activate If TRUE activates the GPS on addition.
#' @param autoCenter If TRUE auto centers the map when GPS location changes
#' @param maxZoom If set zooms to this level when auto centering
#' @param setView If TRUE sets the view to the GPS location when found
#' @rdname gps
#' @export
gpsOptions <- function(
    position = "topleft",
    activate = FALSE,
    autoCenter = FALSE,
    maxZoom = NULL,
    setView = FALSE) {
  leaflet::filterNULL(list(
    position = position,
    activate = activate,
    autoCenter = autoCenter,
    maxZoom = maxZoom,
    setView = setView
  ))
}

#' Add a gps to the Map.
#'
#' @param map a map widget object
#' @param options Options for the GPS control.
#' @rdname gps
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addControlGPS()
addControlGPS <- function(
    map,
    options = gpsOptions()) {
  map$dependencies <- c(map$dependencies, leafletGPSDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "addControlGPS",
    leaflet::filterNULL(options)
  )
}

#' Removes the GPS Control
#' @rdname gps
#' @export
removeControlGPS <- function(map) {
  map$dependencies <- c(map$dependencies, leafletGPSDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "removeControlGPS"
  )
}

#' Activate the GPS Control.
#' You should have already added the GPS control before calling this method.
#' @rdname gps
#' @export
activateGPS <- function(map) {
  map$dependencies <- c(map$dependencies, leafletGPSDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "activateGPS"
  )
}

#' Deactivate the GPS Control.
#' You should have already added the GPS control before calling this method.
#' @rdname gps
#' @export
deactivateGPS <- function(map) {
  map$dependencies <- c(map$dependencies, leafletGPSDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "deactivateGPS"
  )
}
