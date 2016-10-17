# Source https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached
tileLayer.PouchDBCachedDependency <- function() {
  list(
    htmltools::htmlDependency(
      "tileLayer.PouchDBCached",version = "0.1.1",
      system.file("htmlwidgets/lib/TileLayer.PouchDBCached", package = "leaflet.extras"),
      script = c("pouchdb-6.0.7.js","L.TileLayer.PouchDBCached.js")
    )
  )
}

#' Enables caching of Tiles
#' @description Enables caching of tiles locally in browser. See \url{https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached} for details. In addition to invoking this function, you should also pass \code{useCache=TRUE} & \code{crossOrigin=TRUE} in the \code{\link[leaflet]{tileOptions}} call and pass that to your \code{\link[leaflet]{addTiles}}'s \code{options} parameter.
#' @param map The leaflet map
#' @rdname TileCaching
#' @export
#' @examples
#' \dontrun{
#' leaflet() %>%
#'   enableTileCaching() %>%
#'   addTiles(options=tileOptions(useCache=TRUE,crossOrigin=TRUE))
#' }
enableTileCaching <- function(map) {
  map$dependencies <- c(map$dependencies, tileLayer.PouchDBCachedDependency())
  map
}
