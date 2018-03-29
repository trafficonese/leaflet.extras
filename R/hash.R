# Source https://github.com/mlevans/leaflet-hash
hashDependency <- function() {
  list(
    # // "leaflet-hash": "github:PowerPan/leaflet-hash#4020d13",
    html_dep_prod("lfx-hash", "1.0.1")
  )
}

#' Add dynamic URL Hash
#' @description Leaflet-hash lets you to add dynamic URL hashes to web pages with Leaflet maps. You can easily link users to specific map views.
#' @param map The leaflet map
#' @rdname leaflethash
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addHash()
addHash <- function(map) {
  map$dependencies <- c(map$dependencies, hashDependency())
  htmlwidgets::onRender(map, JS("function(el,x,data){var hash = new L.Hash(this);}"))
}
