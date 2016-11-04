addAwesomeMarkersDependencies <- function(map, libs) {
  map$dependencies <- c(map$dependencies,
                        leaflet::leafletDependencies$awesomeMarkers())
  if("fa" %in% libs) {
    map$dependencies <- c(map$dependencies,
                          leaflet::leafletDependencies$fontawesome())
  }
  if("ion" %in% libs) {
    map$dependencies <- c(map$dependencies,
                          leaflet::leafletDependencies$ionicon())
  }
  if("glyphicon" %in% libs) {
    map$dependencies <- c(map$dependencies,
                          leaflet::leafletDependencies$bootstrap())
  }
  map
}
