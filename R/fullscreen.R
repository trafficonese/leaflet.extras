# Source https://github.com/mlevans/leaflet-fullscreen
fullscreenDependency <- function() {
  list(
    # // "leaflet-fullscreen": "1.0.2",
    html_dep_prod("lfx-fullscreen", "1.0.2", has_style = TRUE)
  )
}

#' Add fullscreen control
#' @description Add a fullscreen control button
#' @param map The leaflet map
#' @param position position of control: "topleft", "topright", "bottomleft", or "bottomright"
#' @param pseudoFullscreen if true, fullscreen to page width and height
#' @rdname fullscreen
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addFullscreenControl()
addFullscreenControl <- function(
    map, position = "topleft", pseudoFullscreen = FALSE) {
  map$dependencies <- c(map$dependencies, fullscreenDependency())
  if (is.null(map$x$options)) {
    map$x$options <- list()
  }
  map$x$options["fullscreenControl"] <-
    list(list(position = position, pseudoFullscreen = pseudoFullscreen))
  map
}
