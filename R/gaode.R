leafletGaodeDependencies <- function() {
  list(
      htmltools::htmlDependency(
          "leaflet-providers",
          "1.0.27",
          system.file("htmlwidgets/lib/leaflet-providers", package = "leaflet"),
          script = "leaflet-providers.js"
      ),
    htmltools::htmlDependency(
      "leaflet-gaode",
      packageVersion("leaflet"),
      system.file("htmlwidgets/lib/leaflet-gaode", package = "leaflet.extras"),
      script = "leaflet-gaode.js"
    )
  )
}


#' Add a Gaode tile layer
#'
#' @param map the map to add the tile layer to
#' @param layerId the layer id to assign
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{\link{clearGroup}} and \code{\link{addLayersControl}} purposes).
#'   Human-friendly group names are permitted--they need not be short,
#'   identifier-style names.
#' @return modified map object
#'
#' @examples
#' \dontrun{
#' leaflet() %>%
#'   addTileGaodeMap() %>%
#'   setView(lat = 37.550339, lng = 104.114129, zoom = 4)
#' }
#' @export
addTileGaodeMap <- function(
  map,
  layerId = NULL,
  group = NULL
) {
  map$dependencies <- c(map$dependencies, leafletGaodeDependencies())
  invokeMethod(map, getMapData(map), 'addTileGaodeMap',
               layerId, group)
}




#' Add a Gaode satellite layer
#'
#' @param map the map to add the satellite layer to
#' @param layerId the layer id to assign
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{\link{clearGroup}} and \code{\link{addLayersControl}} purposes).
#'   Human-friendly group names are permitted--they need not be short,
#'   identifier-style names.
#' @return modified map object
#'
#'
#' @examples
#' \dontrun{
#' leaflet() %>%
#'   addTileGaodeSatellite() %>%
#'   setView(lat = 37.550339, lng = 104.114129, zoom = 4)
#' }
#' @export
addTileGaodeSatellite <- function(
    map,
    layerId = NULL,
    group = NULL
) {
    map$dependencies <- c(map$dependencies, leafletGaodeDependencies())
    invokeMethod(map, getMapData(map), 'addTileGaodeSatellite',
                 layerId, group)
}

