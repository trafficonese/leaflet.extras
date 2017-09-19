leafletZoomControlDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "leaflet-movezoom",
      "0.1.0",
      system.file("htmlwidgets/lib/MoveZoomControl", package = "leaflet.extras"),
      script = c("ZoomControl-binding.js")
    )
  )
}

#' Change the location of the zoom control
#'
#' @param map a map widget object
#' @param position the position of the zoom control
#' @examples
#' library(leaflet.extras)
#'
#' leaf <- leaflet() %>%
#'   addTiles() %>%
#'   moveZoomControl()
#'
#' @export
moveZoomControl <- function(map, position = c("bottomright", "bottomleft",
                                              "topright", "topleft")) {
  position = match.arg(position)
  map$dependencies <- c(map$dependencies, leafletZoomControlDependencies())
  invokeMethod(map, getMapData(map), method = "zoomControlPosition",
               position)
}
