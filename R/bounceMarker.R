# Source: https://github.com/maximeh/leaflet.bouncemarker
bounceMarkerDependency <- function() {
  list(
    htmltools::htmlDependency(
      "bouncemarker",
      "0.1.0",
      system.file("htmlwidgets/lib/bouncemarker", package = "leaflet.extras"),
      script = c("bouncemarker.js", "bouncemarker-binding.js")
    ))
}

#' Add Bounce Markers to map
#' @param lat numeric latitude
#' @param lng numeric longitude
#' @param map map object created by [leaflet::leaflet]
#' @param duration integer scalar: The duration of the animation in milliseconds.
#' @param height integer scalar: Height at which the marker is dropped.
#' @md
#' @author Markus Dumke
#' @export
#' @seealso [Github: leaflet.bouncemarker](https://github.com/maximeh/leaflet.bouncemarker)
#' @examples
#' \dontrun{
#' leaflet() %>% addTiles() %>% addBounceMarkers(49, 11)
#' }
addBounceMarkers = function(map, lat, lng, duration = 1000, height = 100) {
  map$dependencies <- c(map$dependencies, bounceMarkerDependency())
  invokeMethod(map, getMapData(map), 'addBounceMarkers', lat, lng, duration, height)
}
