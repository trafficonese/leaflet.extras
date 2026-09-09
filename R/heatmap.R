# Source https://github.com/Leaflet/Leaflet.heat
heatmapDependency <- function() {
  list(
    html_dep_prod("lfx-heat", "0.1.0", has_binding = TRUE)
  )
}

evalHeatmapIntensity <- function(intensity, data) {
  if (is.null(intensity)) {
    return(NULL)
  }
  if (inherits(intensity, "formula")) {
    intensity <- eval(intensity[[2]], data, environment(intensity))
  }
  intensity
}

heatmapIntensityMax <- function(intensity) {
  max_int <- suppressWarnings(max(intensity, na.rm = TRUE))
  if (!is.finite(max_int) || max_int <= 0) {
    return(1)
  }
  max_int
}

leafletHeatRampColors <- function(n = 25) {
  stops <- c(0, 0.4, 0.6, 0.7, 0.8, 1)
  cols <- grDevices::col2rgb(c(
    "#0000FF", "#0000FF", "#00FFFF", "#00FF00", "#FFFF00", "#FF0000"
  ))
  t <- seq(0, 1, length.out = n)
  idx <- findInterval(t, stops, rightmost.closed = TRUE)
  idx[idx < 1] <- 1
  idx[idx >= length(stops)] <- length(stops) - 1
  frac <- (t - stops[idx]) / pmax(stops[idx + 1] - stops[idx], 1e-9)
  rgb <- cols[, idx, drop = FALSE] * (1 - frac) + cols[, idx + 1, drop = FALSE] * frac
  grDevices::rgb(rgb[1, ], rgb[2, ], rgb[3, ], maxColorValue = 255)
}

heatmapLegendColors <- function(gradient = NULL) {
  if (is.null(gradient)) {
    return(leafletHeatRampColors())
  }
  if (is.function(gradient)) {
    return(gradient(seq(0, 1, length.out = 21)))
  }
  if (is.character(gradient) && length(gradient) == 1L) {
    webgl <- webglLegendColors(gradient)
    if (!is.null(webgl)) {
      return(webgl)
    }
  }
  if (is.list(gradient)) {
    return(unlist(gradient, use.names = FALSE))
  }
  gradient
}

webglLegendColors <- function(name) {
  switch(
    name,
    "skyline" = c("#0b1026", "#1b4f8a", "#4ec5d6", "#f4f7ff"),
    "deep-sea" = c("#031163", "#0a4b8c", "#1ec8e6"),
    "BuGn" = c("#edf8fb", "#b2e2e2", "#66c2a4", "#238b45"),
    "BuPu" = c("#edf8fb", "#b3cde3", "#8c96c6", "#88419d"),
    "GnBu" = c("#f0f9e8", "#bae4bc", "#7bccc4", "#2b8cbe"),
    "OrRd" = c("#fef0d9", "#fdcc8a", "#fc8d59", "#d7301f"),
    "PuBu" = c("#f1eef6", "#bdc9e1", "#74a9cf", "#0570b0"),
    "PuBuGn" = c("#f6eff7", "#bdc9e1", "#67a9cf", "#02818a"),
    "PuRd" = c("#f1eef6", "#d7b5d8", "#df65b0", "#ce1256"),
    "RdPu" = c("#feebe2", "#fbb4b9", "#f768a1", "#ae017e"),
    "YlGn" = c("#ffffcc", "#c2e699", "#78c679", "#238443"),
    "YlGnBu" = c("#ffffcc", "#a1dab4", "#41b6c4", "#225ea8"),
    "YlOrBr" = c("#ffffd4", "#fed98e", "#fe9929", "#cc4c02"),
    "YlOrRd" = c("#ffffb2", "#fecc5c", "#fd8d3c", "#e31a1c"),
    NULL
  )
}

#' Add a color legend for a heatmap
#' @param values numeric intensity values. The legend goes from 0 to
#'   \code{max}, matching how Leaflet.heat colors \code{intensity / max}.
#' @param colors a color palette name, a vector of colors, a
#'   \code{\link[leaflet]{colorNumeric}} function, or a WebGL
#'   \code{gradientTexture} name such as \code{"skyline"} or \code{"OrRd"}.
#'   The default matches the Leaflet.heat blue-cyan-lime-yellow-red ramp.
#' @param max upper end of the legend. Defaults to the maximum of \code{values}.
#' @param title legend title
#' @param opacity legend opacity
#' @param ... additional arguments passed to \code{\link[leaflet]{addLegend}}
#' @inheritParams leaflet::addLegend
#' @rdname heatmap-legend
#' @export
#' @examples
#' leaflet(quakes) %>%
#'   addProviderTiles(providers$CartoDB.DarkMatter) %>%
#'   addHeatmap(lng = ~long, lat = ~lat, intensity = ~mag) %>%
#'   addHeatmapLegend(values = quakes$mag, title = "Magnitude")
addHeatmapLegend <- function(
  map,
  values,
  colors = NULL,
  max = NULL,
  title = "Intensity",
  position = "bottomright",
  layerId = NULL,
  opacity = 1,
  ...
) {
  max_val <- if (!is.null(max)) max else heatmapIntensityMax(values)
  rng <- c(0, max_val)
  pal <- leaflet::colorNumeric(
    heatmapLegendColors(colors),
    domain = rng,
    na.color = "#00000000"
  )
  leaflet::addLegend(
    map,
    position = position,
    pal = pal,
    values = rng,
    title = title,
    layerId = layerId,
    opacity = opacity,
    ...
  )
}

#' Add a heatmap
#' @param intensity intensity of the heat. A vector of numeric values or a formula.
#'   Values are interpreted relative to \code{max}. If \code{scaleIntensity = TRUE}
#'   and \code{max} is left at the default, values greater than 1 are scaled
#'   automatically so that 1 and 500 stay visually distinct.
#' @param minOpacity minimum opacity at which the heat will start
#' @param max  maximum point intensity. The default is \code{1.0}
#' @param radius radius of each "point" of the heatmap.  The default is
#'          \code{25}.
#' @param blur amount of blur to apply.  The default is \code{15}.
#'          \code{blur=1} means no blur.
#' @param gradient palette name from \code{RColorBrewer} or an array of
#'          of colors to be provided to \code{\link[leaflet]{colorNumeric}}, or
#'          a color mapping function returned from \code{colorNumeric}
#' @param cellSize  the cell size in the grid. Points which are closer
#'          than this may be merged. Defaults to `radius / 2`.s
#'          Set to `1` to do almost no merging.
#' @param maxZoom zoom level at which a point reaches its full intensity.
#'   Leaflet.heat otherwise fades points at low zoom, which makes everything
#'   look blue and hides \code{intensity}. When \code{scaleIntensity = TRUE}
#'   and \code{maxZoom} is \code{NULL}, it defaults to \code{0} so weights
#'   stay visible at world/regional zoom.
#' @param scaleIntensity If \code{TRUE} (default) and \code{max} was not set
#'   by the caller, \code{max} becomes the maximum intensity so raw values
#'   such as 1 vs 500 are visible. Set to \code{FALSE} to keep the previous
#'   clipping behavior.
#' @param legend If \code{TRUE}, add a color legend for the intensity scale.
#' @param legendOptions A list of arguments passed to \code{\link{addHeatmapLegend}},
#'   such as \code{title} or \code{position}.
#' @inheritParams leaflet::addCircleMarkers
#' @rdname heatmap
#' @export
#' @examples
#' leaflet(quakes) %>%
#'   addProviderTiles(providers$CartoDB.DarkMatter) %>%
#'   setView(178, -20, 5) %>%
#'   addHeatmap(
#'     lng = ~long, lat = ~lat, intensity = ~mag,
#'     blur = 20, radius = 15, legend = TRUE
#'   )
#'
#' ## for more examples see
#' # browseURL(system.file("examples/heatmaps.R", package = "leaflet.extras"))
addHeatmap <- function(
  map, lng = NULL, lat = NULL, intensity = NULL, layerId = NULL, group = NULL,
  minOpacity = 0.05,
  max = 1.0, radius = 25,
  blur = 15, gradient = NULL, cellSize = NULL,
  maxZoom = NULL,
  scaleIntensity = TRUE,
  legend = FALSE,
  legendOptions = NULL,
  data = leaflet::getMapData(map)
) {
  map$dependencies <- c(
    map$dependencies,
    heatmapDependency()
  )

  legend_colors <- gradient
  # convert gradient to expected format from leaflet
  if (!is.null(gradient)) {
    if (!is.function(gradient)) {
      gradient <- colorNumeric(gradient, 0:1, alpha = TRUE)
    }
    gradient <- as.list(gradient(0:20 / 20))
    names(gradient) <- as.character(0:20 / 20)
  }

  pts <- leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addHeatmap"
  )

  intensity <- evalHeatmapIntensity(intensity, data)
  if (!is.null(intensity) && isTRUE(scaleIntensity) && missing(max)) {
    max <- heatmapIntensityMax(intensity)
    if (is.null(maxZoom)) {
      maxZoom <- 0
    }
  }

  if (is.null(intensity)) {
    points <- cbind(pts$lat, pts$lng)
  } else {
    points <- cbind(pts$lat, pts$lng, intensity)
  }

  map <- leaflet::invokeMethod(
    map, data, "addHeatmap", points,
    layerId, group,
    leaflet::filterNULL(list(
      minOpacity = minOpacity,
      max = max,
      radius = radius,
      blur = blur,
      gradient = gradient,
      cellSize = cellSize,
      maxZoom = maxZoom
    ))
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)

  if (isTRUE(legend)) {
    legend_values <- if (is.null(intensity)) c(0, max) else intensity
    map <- do.call(
      addHeatmapLegend,
      c(
        list(
          map = map,
          values = legend_values,
          colors = legend_colors,
          max = max
        ),
        legendOptions
      )
    )
  }
  map
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
  blur = 15, gradient = NULL, cellSize = NULL
) {
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
  blur = 15, gradient = NULL, cellSize = NULL
) {
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
  blur = 15, gradient = NULL, cellSize = NULL
) {
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
  blur = 15, gradient = NULL, cellSize = NULL
) {
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
