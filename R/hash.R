# Source https://github.com/mlevans/leaflet-hash
hashDependency <- function() {
  list(
    htmltools::htmlDependency(
      "hash",version = "0.2.1",
      system.file("htmlwidgets/lib/hash", package = "leaflet.extras"),
      script = c("leaflet-hash.js")
    )
  )
}

#' Add dynamic URL Hash
#' @description Leaflet-hash lets you to add dynamic URL hashes to web pages with Leaflet maps. You can easily link users to specific map views.
#' @param map The leaflet map
#' @rdname leaflethash
#' @export
#' @examples
#' \dontrun{
#' leaflet() %>% addTiles() %>%
#'   addHash()
#' }
addHash <- function(map) {
  map$dependencies <- c(map$dependencies, hashDependency())
  htmlwidgets::onRender(map,JS("function(el,x,data){var hash = new L.Hash(this);}"))
}
