# Source https://github.com/Leaflet/Leaflet.heat
heatmapDependency <- function() {
  list(
    html_dep_prod("lfx-heat", "0.1.0", has_binding = TRUE)
  )
}

#' Add a heatmap
#' @param map the map widget.
#' @param lng a numeric vector of longitudes, or a one-sided formula of the form
#'   \code{~x} where \code{x} is a variable in \code{data}; by default (if not
#'   explicitly provided), it will be automatically inferred from \code{data} by
#'   looking for a column named \code{lng}, \code{long}, or \code{longitude}
#'   (case-insensitively)
#' @param lat a vector of latitudes or a formula (similar to the \code{lng}
#'   argument; the names \code{lat} and \code{latitude} are used when guessing
#'   the latitude column from \code{data})
#' @param intensity intensity of the heat. A vector of numeric values or a formula.
#' @param minOpacity minimum opacity at which the heat will start
#' @param max  maximum point intensity. The default is \code{1.0}
#' @param radius radius of each "point" of the heatmap.  The default is
#'          \code{25}.
#' @param blur amount of blur to apply.  The default is \code{15}.
#'          \code{blur=1} means no blur.
#' @param gradient palette name from \code{RColorBrewer} or an array of
#'          of colors to be provided to \code{\link{colorNumeric}}, or
#'          a color mapping function returned from \code{colorNumeric}
#' @param cellSize  the cell size in the grid. Points which are closer
#'          than this may be merged. Defaults to `radius / 2`.s
#'          Set to `1` to do almost no merging.
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{\link{clearGroup}} and \code{\link{addLayersControl}} purposes).
#'   Human-friendly group names are permitted--they need not be short,
#'   identifier-style names. Any number of layers and even different types of
#'   layers (e.g. markers and polygons) can share the same group name.
#' @param data the data object from which the argument values are derived; by
#'   default, it is the \code{data} object provided to \code{leaflet()}
#'   initially, but can be overridden
#' @rdname heatmap
#' @export
#' @examples
#' leaflet(quakes) %>%
#'   addProviderTiles(providers$CartoDB.DarkMatter) %>%
#'   setView(178, -20, 5) %>%
#'   addHeatmap(
#'     lng = ~long, lat = ~lat, intensity = ~mag,
#'     blur = 20, max = 0.05, radius = 15
#'   )
#'
#' ## for more examples see
#' # browseURL(system.file("examples/heatmaps.R", package = "leaflet.extras"))
addHeatmap <- function(
    map, lng = NULL, lat = NULL, intensity = NULL, layerId = NULL, group = NULL,
    minOpacity = 0.05,
    max = 1.0, radius = 25,
    blur = 15, gradient = NULL, cellSize = NULL,
    data = leaflet::getMapData(map)) {
  map$dependencies <- c(
    map$dependencies,
    heatmapDependency()
  )

  # convert gradient to expected format from leaflet
  if (!is.null(gradient) && !is.function(gradient)) {
    gradient <- colorNumeric(gradient, 0:1)
    gradient <- as.list(gradient(0:20 / 20))
    names(gradient) <- as.character(0:20 / 20)
  }

  pts <- leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addHeatmap"
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
    map, data, "addHeatmap", points,
    layerId, group,
    leaflet::filterNULL(list(
      minOpacity = minOpacity,
      max = max,
      radius = radius,
      blur = blur,
      gradient = gradient,
      cellSize = cellSize
    ))
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}

#' Adds a heatmap with data from a GeoJSON/TopoJSON file/url
#' @param geojson The geojson or topojson url or contents as string.
#' @param intensityProperty The property to use for determining the intensity at a point.
#' Can be a "string" or a JS function, or NULL.
#' @rdname heatmap
#' @export
addGeoJSONHeatmap <- function(
    map, geojson, layerId = NULL, group = NULL,
    intensityProperty = NULL,
    minOpacity = 0.05,
    max = 1.0, radius = 25,
    blur = 15, gradient = NULL, cellSize = NULL) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, heatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addGeoJSONHeatmap", geojson, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      minOpacity = minOpacity,
      max = max,
      radius = radius,
      blur = blur,
      gradient = gradient,
      cellSize = cellSize
    ))
  )
}

#' Adds a heatmap with data from a KML file/url
#' @param kml The KML url or contents as string.
#' @rdname heatmap
#' @export
#' @examples
#' kml <- readr::read_file(
#'   system.file("examples/data/kml/crimes.kml.zip", package = "leaflet.extras")
#' )
#'
#' leaflet() %>%
#'   setView(-77.0369, 38.9072, 12) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addKMLHeatmap(kml, radius = 7) %>%
#'   addKML(
#'     kml,
#'     markerType = "circleMarker",
#'     stroke = FALSE, fillColor = "black", fillOpacity = 1,
#'     markerOptions = markerOptions(radius = 1)
#'   )
#'
#' ## for more examples see
#' # browseURL(system.file("examples/KML.R", package = "leaflet.extras"))
addKMLHeatmap <- function(
    map, kml, layerId = NULL, group = NULL,
    intensityProperty = NULL,
    minOpacity = 0.05,
    max = 1.0, radius = 25,
    blur = 15, gradient = NULL, cellSize = NULL) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, heatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addKMLHeatmap", kml, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      minOpacity = minOpacity,
      max = max,
      radius = radius,
      blur = blur,
      gradient = gradient,
      cellSize = cellSize
    ))
  )
}

#' Adds a heatmap with data from a CSV file/url
#' @param csv The CSV url or contents as string.
#' @param csvParserOptions options for parsing the CSV.
#' Use \code{\link{csvParserOptions}}() to supply csv parser options.
#' @rdname heatmap
#' @export
addCSVHeatmap <- function(
    map, csv, csvParserOptions, layerId = NULL, group = NULL,
    intensityProperty = NULL,
    minOpacity = 0.05,
    max = 1.0, radius = 25,
    blur = 15, gradient = NULL, cellSize = NULL) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, heatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addCSVHeatmap", csv, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      minOpacity = minOpacity,
      max = max,
      radius = radius,
      blur = blur,
      gradient = gradient,
      cellSize = cellSize
    )),
    csvParserOptions
  )
}

#' Adds a heatmap with data from a GPX file/url
#' @param gpx The GPX url or contents as string.
#' @rdname heatmap
#' @export
addGPXHeatmap <- function(
    map, gpx, layerId = NULL, group = NULL,
    intensityProperty = NULL,
    minOpacity = 0.05,
    max = 1.0, radius = 25,
    blur = 15, gradient = NULL, cellSize = NULL) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies, heatmapDependency())

  leaflet::invokeMethod(
    map, leaflet::getMapData(map),
    "addGPXHeatmap", gpx, intensityProperty,
    layerId, group,
    leaflet::filterNULL(list(
      minOpacity = minOpacity,
      max = max,
      radius = radius,
      blur = blur,
      gradient = gradient,
      cellSize = cellSize
    ))
  )
}


#' removes the heatmap
#' @rdname heatmap
#' @export
removeHeatmap <- function(map, layerId) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), "removeHeatmap", layerId)
}

#' clears the heatmap
#' @rdname heatmap
#' @export
clearHeatmap <- function(map) {
  leaflet::invokeMethod(map, NULL, "clearHeatmap")
}
