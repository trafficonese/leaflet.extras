# Source: https://github.com/maximeh/leaflet.bouncemarker
bounceMarkerDependency <- function() {
  list(
    # // "leaflet.BounceMarker": "github:maximeh/leaflet.bouncemarker#v1.1",
    # bounce bindings
    html_dep_prod("lfx-bouncemarker", "1.1.0", has_binding = TRUE)
  )

}

#' Add Bounce Markers to map
#' @param map map object created by [leaflet::leaflet]
#' @param lat numeric latitude
#' @param lng numeric longitude
#' @param duration integer scalar: The duration of the animation in milliseconds.
#' @param height integer scalar: Height at which the marker is dropped.
#' @md
#' @author Markus Dumke
#' @export
#' @seealso [GitHub: leaflet.bouncemarker](https://github.com/maximeh/leaflet.bouncemarker)
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addBounceMarkers(49, 11)
addBounceMarkers = function(map, lat, lng, duration = 1000, height = 100) {
  map$dependencies <- c(map$dependencies, bounceMarkerDependency())
  invokeMethod(map, getMapData(map), 'addBounceMarkers', lat, lng, duration, height)
}
