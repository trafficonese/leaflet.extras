# Source https://github.com/mlevans/leaflet-fullscreen
fullscreenDependency <- function() {
  list(
    htmltools::htmlDependency(
      "fullscreen",version = "1.0.1",
      system.file("htmlwidgets/lib/fullscreen", package = "leaflet.extras"),
      script = c("Leaflet.fullscreen.min.js"),
      stylesheet = c("leaflet.fullscreen.css")

    )
  )
}

#' Add fullscreen control
#' @description Add a fullscreen control button
#' @param map The leaflet map
#' @param position position of control: 'topleft', 'topright', 'bottomleft', or 'bottomright'
#' @param pseudoFullscreen if true, fullscreen to page width and height
#' @rdname fullscreen
#' @export
#' @examples
#' \dontrun{
#' leaflet() %>% addTiles() %>%
#'   addFullscreenControl()
#' }
addFullscreenControl <- function(
  map, position = 'topleft', pseudoFullscreen = FALSE) {
  map$dependencies <- c(map$dependencies, fullscreenDependency())
  if (is.null(map$x$options))
    map$x$options <- list()
  map$x$options['fullscreenControl'] <-
    list(list(position = position, pseudoFullscreen = pseudoFullscreen))
  map
}
