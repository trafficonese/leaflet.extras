webGLHeatmapDependency <- function() {
  list(
    # // "leaflet-webgl-heatmap": "0.2.7",
    html_dep_prod(
      "lfx-webgl-heatmap", "0.2.7",
      attachment = list(
        "skyline" = "skyline-gradient.png",
        "deep-sea" = "deep-sea-gradient.png",
        "BuGn" = "BuGn.png",
        "BuPu" = "BuPu.png",
        "GnBu" = "GnBu.png",
        "OrRd" = "OrRd.png",
        "PuBu" = "PuBu.png",
        "PuBuGn" = "PuBuGn.png",
        "PuRd" = "PuRd.png",
        "RdPu" = "RdPu.png",
        "YlGn" = "YlGn.png",
        "YlGnBu" = "YlGnBu.png",
        "YlOrBr" = "YlOrBr.png",
        "YlOrRd" = "YlOrRd.png"
      ),
      has_binding = TRUE
    )
  )
}

#' Add a webgl heatmap
#' @param intensity intensity of the heat. A vector of numeric values or a formula.
#' @param size in meters or pixels
#' @param units either "m" or "px"
#' @param opacity for the canvas element
#' @param gradientTexture Alternative colors for heatmap.
#'    allowed values are "skyline", "deep-sea"
#' @param alphaRange adjust transparency by changing to value between 0 and 1
#' @inheritParams leaflet::addCircleMarkers
#' @rdname webglheatmap
#' @export
#' @examples
#' ## addWebGLHeatmap
#' leaflet(quakes) %>%
#'   addProviderTiles(providers$CartoDB.DarkMatter) %>%
#'   addWebGLHeatmap(lng = ~long, lat = ~lat, size = 60000)
#'
#' ## for more examples see
#' # browseURL(system.file("examples/webglHeatmaps.R", package = "leaflet.extras"))
addWebGLHeatmap <- function(
  map, lng = NULL, lat = NULL, intensity = NULL, layerId = NULL, group = NULL,
  size = "30000",
  units = "m",
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1,
  data = leaflet::getMapData(map)
) {
  map$dependencies <- c(
    map$dependencies,
    webGLHeatmapDependency()
  )

  gradients <- c(
    "skyline", "deep-sea", "BuGn", "BuPu", "GnBu",
    "OrRd", "PuBu", "PuBuGn", "PuRd", "RdPu",
    "YlGn", "YlGnBu", "YlOrBr", "YlOrRd"
  )

  if (!is.null(gradientTexture) &&
    !gradientTexture %in% gradients) {
    stop("Only allowed values for 'gradientTexture' are:\n", paste0("'", gradients, "'", collapse = ", "))
  }

  pts <- leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addWebGLHeatmap"
  )

  if (is.null(intensity)) {
    points <- cbind(pts$lat, pts$lng)
  } else {
    if (inherits(intensity, "formula")) {
      intensity <- eval(intensity[[2]], data, environment(intensity))
    }
    points <- cbind(pts$lat, pts$lng, intensity)
  }

  leaflet::invokeMethod(
    map, data, "addWebGLHeatmap", points,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    ))
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}

#' Adds a heatmap with data from a GeoJSON/TopoJSON file/url
#' @param geojson The geojson or topojson url or contents as string.
#' @param intensityProperty The property to use for determining the intensity at a point.
#' Can be a "string" or a JS function, or NULL.
#' @rdname webglheatmap
#' @export
#' @examples
#' ## addWebGLGeoJSONHeatmap
#' \donttest{
#' geoJson <- readr::read_file(
#'   "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
#' )
#'
#' leaflet() %>%
#'   setView(-77.0369, 38.9072, 12) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addWebGLGeoJSONHeatmap(
#'     geoJson,
#'     size = 30, units = "px"
#'   ) %>%
#'   addGeoJSONv2(
#'     geoJson,
#'     markerType = "circleMarker",
#'     stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
#'     markerOptions = markerOptions(radius = 2)
#'   )
#' }
#'
#' ## for more examples see
#' # browseURL(system.file("examples/geojsonV2.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/TopoJSON.R", package = "leaflet.extras"))
addWebGLGeoJSONHeatmap <- function(
  map, geojson, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = "30000",
  units = "m",
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
) {
  map$dependencies <- c(
    map$dependencies,
    omnivoreDependencies(),
    webGLHeatmapDependency()
  )

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addWebGLGeoJSONHeatmap", geojson, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    ))
  )
}

#' Adds a heatmap with data from a KML file/url
#' @param kml The KML url or contents as string.
#' @rdname webglheatmap
#' @export
#' @examples
#' ## addWebGLKMLHeatmap
#' \donttest{
#' kml <- readr::read_file(
#'   system.file("examples/data/kml/crimes.kml.zip", package = "leaflet.extras")
#' )
#'
#' leaflet() %>%
#'   setView(-77.0369, 38.9072, 12) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addWebGLKMLHeatmap(kml, size = 20, units = "px") %>%
#'   addKML(
#'     kml,
#'     markerType = "circleMarker",
#'     stroke = FALSE, fillColor = "black", fillOpacity = 1,
#'     markerOptions = markerOptions(radius = 1)
#'   )
#' }
#'
addWebGLKMLHeatmap <- function(
  map, kml, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = "30000",
  units = "m",
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addWebGLKMLHeatmap", kml, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    ))
  )
}

#' Adds a heatmap with data from a CSV file/url
#' @param csv The CSV url or contents as string.
#' @param csvParserOptions options for parsing the CSV.
#' Use \code{\link{csvParserOptions}}() to supply csv parser options.
#' @rdname webglheatmap
#' @export
#' @examples
#' ## addWebGLCSVHeatmap
#' \donttest{
#' csv <- readr::read_file(
#'   system.file("examples/data/csv/world_airports.csv.zip", package = "leaflet.extras")
#' )
#'
#' leaflet() %>%
#'   setView(0, 0, 2) %>%
#'   addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%
#'   addWebGLCSVHeatmap(
#'     csv,
#'     csvParserOptions("latitude_deg", "longitude_deg"),
#'     size = 10, units = "px"
#'   )
#' }
#'
addWebGLCSVHeatmap <- function(
  map, csv, csvParserOptions, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = "30000",
  units = "m",
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addWebGLCSVHeatmap", csv, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    )),
    csvParserOptions
  )
}

#' Adds a heatmap with data from a GPX file/url
#' @param gpx The GPX url or contents as string.
#' @rdname webglheatmap
#' @export
#' @examples
#' \donttest{
#' airports <- readr::read_file(
#'   system.file("examples/data/gpx/md-airports.gpx.zip", package = "leaflet.extras")
#' )
#'
#' leaflet() %>%
#'   addBootstrapDependency() %>%
#'   setView(-76.6413, 39.0458, 8) %>%
#'   addProviderTiles(
#'     providers$CartoDB.Positron,
#'     options = providerTileOptions(detectRetina = TRUE)
#'   ) %>%
#'   addWebGLGPXHeatmap(
#'     airports,
#'     size = 20000,
#'     group = "airports",
#'     opacity = 0.9
#'   ) %>%
#'   addGPX(
#'     airports,
#'     markerType = "circleMarker",
#'     stroke = FALSE, fillColor = "black", fillOpacity = 1,
#'     markerOptions = markerOptions(radius = 1.5),
#'     group = "airports"
#'   )
#' }
#'
#'
#' ## for a larger example see
#' # browseURL(system.file("examples/GPX.R", package = "leaflet.extras"))
addWebGLGPXHeatmap <- function(
  map, gpx, layerId = NULL, group = NULL,
  intensityProperty = NULL,
  size = "30000",
  units = "m",
  opacity = 1,
  gradientTexture = NULL,
  alphaRange = 1
) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, webGLHeatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addWebGLGPXHeatmap", gpx, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      size = size,
      units = units,
      opacity = opacity,
      gradientTexture = gradientTexture,
      alphaRange = alphaRange
    ))
  )
}


#' removes the webgl heatmap
#' @rdname webglheatmap
#' @export
removeWebGLHeatmap <- function(map, layerId) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), "removeWebGLHeatmap", layerId)
}

#' clears the webgl heatmap
#' @rdname webglheatmap
#' @export
clearWebGLHeatmap <- function(map) {
  leaflet::invokeMethod(map, NULL, "clearWebGLHeatmap")
}
