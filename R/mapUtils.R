utilsDependencies <- function() {
  list(
    html_dep_binding("map-widget-style", "1.0.0")
  )
}

#' Customize the leaflet widget style
#' @param map the map widget
#' @param style a A list of CSS key/value properties.
#' @rdname utils
#' @export
#' @examples
#' \donttest{
#' geoJson <- jsonlite::fromJSON(readr::read_file(
#'   paste0(
#'     "https://raw.githubusercontent.com/MinnPost/simple-map-d3",
#'     "/master/example-data/world-population.geo.json"
#'   )
#' ))
#'
#' world <- leaflet(
#'   options = leafletOptions(
#'     maxZoom = 5,
#'     crs = leafletCRS(
#'       crsClass = "L.Proj.CRS", code = "ESRI:53009",
#'       proj4def = "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs",
#'       resolutions = c(65536, 32768, 16384, 8192, 4096, 2048)
#'     )
#'   )
#' ) %>%
#'   addGraticule(style = list(color = "#999", weight = 0.5, opacity = 1, fill = NA)) %>%
#'   addGraticule(sphere = TRUE, style = list(color = "#777", weight = 1, opacity = 0.25, fill = NA))
#'
#' world
#'
#' # change background to white
#' world %>%
#'   setMapWidgetStyle(list(background = "white"))
#' }
#'
setMapWidgetStyle <- function(
    map,
    style = list(background = "transparent")) {
  map$dependencies <- c(map$dependencies, utilsDependencies())
  invokeMethod(map, getMapData(map), "setMapWidgetStyle", style)
}

#' For debugging a leaflet map
#' @param map The map widget
#' @export
debugMap <- function(map) {
  map %>% htmlwidgets::onRender(htmlwidgets::JS("function(el, x){var map=this; debugger;}"))
}

#' Reset map's view to original view
#' @param map The map widget
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addResetMapButton()
addResetMapButton <- function(map) {
  map %>%
    addEasyButton(easyButton(
      icon = "ion-arrow-shrink",
      title = "Reset View",
      onClick = JS("function(btn, map){ map.setView(map._initialCenter, map._initialZoom); }")
    )) %>%
    htmlwidgets::onRender(JS(
      "
function(el, x){
  var map = this;
  map.whenReady(function(){
    map._initialCenter = map.getCenter();
    map._initialZoom = map.getZoom();
  });
}"
    ))
}
