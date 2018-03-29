tileLayer.PouchDBCachedDependency <- function() {
  list(
    # // "pouchdb-browser": "6.4.3",
    html_dep_prod("pouchdb-browser", "6.4.3"),
    # // "leaflet.tilelayer.pouchdbcached": "nikolauskrismer/Leaflet.TileLayer.PouchDBCached#a92b176",
    html_dep_prod("lfx-tilelayer", "0.3.0")
  )
}

#' Enables caching of Tiles
#' @description Enables caching of tiles locally in browser. See \url{https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached} for details. In addition to invoking this function, you should also pass \code{useCache=TRUE} & \code{crossOrigin=TRUE} in the \code{\link[leaflet]{tileOptions}} call and pass that to your \code{\link[leaflet]{addTiles}}'s \code{options} parameter.
#' @param map The leaflet map
#' @rdname TileCaching
#' @export
#' @examples
#' leaflet() %>%
#'   enableTileCaching() %>%
#'   addTiles(options = tileOptions(useCache = TRUE, crossOrigin = TRUE))
#'
#' ## for more examples see
#' # browseURL(system.file("examples/TileLayer-Caching.R", package = "leaflet.extras"))
enableTileCaching <- function(map) {
  map$dependencies <- c(map$dependencies, tileLayer.PouchDBCachedDependency())
  map
}
