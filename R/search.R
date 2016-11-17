leafletSearchDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "leaflet-search",
      "1.9.7",
      system.file("htmlwidgets/lib/leaflet-search", package = "leaflet.extras"),
      script = c("leaflet-search.min.js",
                 "leaflet-search-binding.js"),
      stylesheet = "leaflet-search.min.css"
    ))
}

#' Add a OSM search control to the map.
#'
#' @param map a map widget object
#' @param url The search url for open street map
#' @param position standard \href{http://leafletjs.com/reference.html#control-positions}{Leaflet control position options}.
#' @return modified map
#' @examples
#' leaflet(data = quakes) %>%
#' addTiles() %>%
#'     addSearchOSM()
#' @export
addSearchOSM <- function(
  map
  , url = 'http://nominatim.openstreetmap.org/search?format=json&q={s}'
  , position = "topright") {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map
    , getMapData(map)
    , 'addSearchOSM'
    , url
    , position
  )
}



#' Add a marker search control to the map.
#'
#' @param map a map widget object
#' @param group a searchable group
#' @param position standard \href{http://leafletjs.com/reference.html#control-positions}{Leaflet control position options}.
#' @param propertyName property in marker.options(or feature.properties for
#'  vector layer) trough filter elements in layer
#' @param initial search elements only by initial text
#' @return modified map
#' @examples
#' data(quakes)
#' leaflet(data = quakes) %>%
#'     addTiles() %>%
#'     addMarkers(~long, ~lat, popup = ~as.character(mag),
#'                group = 'marker', label = ~as.character(mag)) %>%
#'     addSearchMarker('marker', position = 'topleft', propertyName = 'popup')
#' @export
addSearchMarker <- function(
    map
    , group
    , position = "topright"
    , propertyName = 'label'
    , initial = FALSE) {
    map$dependencies <- c(map$dependencies, leafletSearchDependencies())
    invokeMethod(
        map
        , getMapData(map)
        , 'addSearchMarker'
        , group
        , position
        , propertyName
        , initial
    )
}



