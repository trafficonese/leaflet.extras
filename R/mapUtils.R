utilsDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "leaflet.extras-utils",version = "0.1.0",
      system.file("htmlwidgets/lib/utils", package = "leaflet.extras"),
      script = c("leaflet_extras-utils.js")
    )
  )
}

#' Customize the leaflet widget style
#' @param map the map widget
#' @param style a A list of CSS key/value properties.
#' @rdname utils
#' @export
setMapWidgetStyle <- function(
  map,
  style = list(background='transparent')) {
  map$dependencies <- c(map$dependencies, utilsDependencies())
  invokeMethod(map, getMapData(map), 'setMapWidgetStyle', style)
}

#' For debugging a leaflet map
#' @param map The map widget
#' @export
debugMap <- function(map) {
  map %>% htmlwidgets::onRender(htmlwidgets::JS("function(el, x){var map=this; debugger;}"))
}
