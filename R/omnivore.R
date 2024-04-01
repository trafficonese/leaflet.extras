omnivoreDependencies <- function() {
  list(
    # // "csv2geojson": "5.0.2",
    # // "togeojson": "0.16.0",
    # // "topojson": "3.0.2"
    html_dep_prod("csv2geojson", "5.0.2"),
    html_dep_prod("togeojson", "0.16.0"),
    html_dep_prod("topojson", "3.0.2"),
    # polyline is not implemented
    # wellknown is not implemented

    # // "@mapbox/leaflet-omnivore": "0.3.4",
    html_dep_prod("lfx-omnivore", "3.0.2", has_binding = TRUE)
  )
}

# Source https://github.com/timwis/leaflet-choropleth
# Source New https://github.com/trafficonese/leaflet-choropleth
geoJSONChoroplethDependency <- function() {
  list(
    # // "leaflet-choropleth": "1.1.4",
    html_dep_prod("lfx-choropleth", "1.1.4")
  )
}


# Utility Function
invokeJSAddMethod <- function(
    jsMethod, # The javascript method to invoke
    map, data, layerId = NULL, group = NULL,
    markerType = NULL, markerIcons = NULL,
    markerIconProperty = NULL, markerOptions = leaflet::markerOptions(),
    clusterOptions = NULL, clusterId = NULL,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    fill = TRUE,
    fillColor = color,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL,
    ...) {
  if (!is.null(markerType) && !(markerType %in% c("marker", "circleMarker"))) {
    stop("markerType if specified then it needs to be either \"marker\" or \"clusterMarker\"")
  }

  map$dependencies <- c(map$dependencies, omnivoreDependencies())

  if (!is.null(clusterOptions)) {
    map$dependencies <- c(
      map$dependencies,
      leaflet::leafletDependencies$markerCluster()
    )
  }

  pathOptions <- c(pathOptions, list(
    stroke = stroke, color = color, weight = weight, opacity = opacity,
    fill = fill, fillColor = fillColor, fillOpacity = fillOpacity,
    dashArray = dashArray, smoothFactor = smoothFactor, noClip = noClip
  ))

  markerIconFunction <- NULL
  if (!is.null(markerIcons)) {
    if (inherits(markerIcons, "leaflet_icon_set") ||
      inherits(markerIcons, "leaflet_icon")) {
      markerIconFunction <- defIconFunction
    } else if (inherits(markerIcons, "leaflet_awesome_icon_set") ||
      inherits(markerIcons, "leaflet_awesome_icon")) {
      if (inherits(markerIcons, "leaflet_awesome_icon_set")) {
        libs <- unique(sapply(markerIcons, function(icon) icon$library))
        map <- addAwesomeMarkersDependencies(map, libs)
      } else {
        map <- addAwesomeMarkersDependencies(map, markerIcons$library)
      }
      markerIconFunction <- awesomeIconFunction
    } else {
      stop("markerIcons should be created using either leaflet::iconList() or leaflet::awesomeIconList()")
    }
  }

  if (missing(...)) {
    invokeMethod(
      map, getMapData(map), jsMethod, data, layerId, group,
      markerType, markerIcons,
      markerIconProperty, markerOptions, markerIconFunction,
      clusterOptions, clusterId,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    )
  } else {
    invokeMethod(
      map, getMapData(map), jsMethod, data, layerId, group,
      markerType, markerIcons,
      markerIconProperty, markerOptions, markerIconFunction,
      clusterOptions, clusterId,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions, ...
    )
  }
}


#' Adds a GeoJSON/TopoJSON to the leaflet map.
#' @description  This is a feature rich alternative to the \code{\link[leaflet]{addGeoJSON}} & \code{\link[leaflet]{addTopoJSON}}
#' with options to map feature properties to labels, popups, colors, markers etc.
#' @param map the leaflet map widget
#' @param geojson a GeoJSON/TopoJSON URL or file contents in a character vector.
#' @param layerId the layer id
#' @param group the name of the group this raster image should belong to (see
#'   the same parameter under \code{\link{addTiles}})
#' @param markerType The type of marker.  either "marker" or "circleMarker"
#' @param markerIcons Icons for Marker.
#' Can be a single marker using \code{\link[leaflet]{makeIcon}}
#' or a list of markers using \code{\link[leaflet]{iconList}}
#' @param markerIconProperty The property of the feature to use for marker icon.
#' Can be a JS function which accepts a feature and returns an index of \code{markerIcons}.
#' In either case the result must be one of the indexes of markerIcons.
#' @param markerOptions The options for markers
#' @param clusterOptions if not \code{NULL}, markers will be clustered using
#'   \href{https://github.com/Leaflet/Leaflet.markercluster}{Leaflet.markercluster};
#'    you can use \code{\link[leaflet]{markerClusterOptions}()} to specify marker cluster
#'   options
#' @param clusterId the id for the marker cluster layer
#' @param labelProperty The property to use for the label.
#' You can also pass in a JS function that takes in a feature and returns a text/HTML content.
#' @param labelOptions A Vector of \code{\link{labelOptions}} to provide label
#' @param popupProperty The property to use for popup content
#' You can also pass in a JS function that takes in a feature and returns a text/HTML content.
#' @param popupOptions A Vector of \code{\link{popupOptions}} to provide popups
#' @param stroke whether to draw stroke along the path (e.g. the borders of
#'   polygons or circles)
#' @param color stroke color
#' @param weight stroke width in pixels
#' @param opacity stroke opacity (or layer opacity for tile layers)
#' @param fill whether to fill the path with color (e.g. filling on polygons or
#'   circles)
#' @param fillColor fill color
#' @param fillOpacity fill opacity
#' @param dashArray a string that defines the stroke
#'   \href{https://developer.mozilla.org/en/SVG/Attribute/stroke-dasharray}{dash
#'   pattern}
#' @param smoothFactor how much to simplify the polyline on each zoom level
#'   (more means better performance and less accurate representation)
#' @param noClip whether to disable polyline clipping
#' @param pathOptions Options for shapes
#' @param highlightOptions Options for highlighting the shape on mouse over.
#' options for each label. Default \code{NULL}
#'    you can use \code{\link[leaflet]{highlightOptions}()} to specify highlight
#'   options
#' @rdname omnivore
#' @export
#' @examples
#' ## addGeoJSONv2
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
#' # browseURL(system.file("examples/draw.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/geojsonv2.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/search.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/TopoJSON.R", package = "leaflet.extras"))
#'
addGeoJSONv2 <- function(
    map, geojson, layerId = NULL, group = NULL,
    markerType = NULL, markerIcons = NULL,
    markerIconProperty = NULL, markerOptions = leaflet::markerOptions(),
    clusterOptions = NULL, clusterId = NULL,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    fill = TRUE,
    fillColor = color,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL) {
  invokeJSAddMethod(
    "addGeoJSONv2",
    map, geojson, layerId, group,
    markerType, markerIcons,
    markerIconProperty, markerOptions,
    clusterOptions, clusterId,
    labelProperty, labelOptions, popupProperty, popupOptions,
    stroke,
    color,
    weight,
    opacity,
    fill,
    fillColor,
    fillOpacity,
    dashArray,
    smoothFactor,
    noClip,
    pathOptions, highlightOptions
  )
}

#' Options to customize a Choropleth Legend
#' @param title An optional title for the legend
#' @param position legend position
#' @param locale The numbers will be formatted using this locale
#' @param numberFormatOptions Options for formatting numbers
#' @export
#' @rdname omnivore
legendOptions <- function(
    title = NULL,
    position = c("bottomleft", "bottomright", "topleft", "topright"),
    locale = "en-US",
    numberFormatOptions = list(
      style = "decimal",
      maximumFractionDigits = 2
    )) {
  position <- match.arg(position)
  leaflet::filterNULL(
    list(
      title = title,
      position = position,
      formatOptions = list(
        locale = locale,
        options = numberFormatOptions
      )
    )
  )
}

#' Adds a GeoJSON/TopoJSON Choropleth.
#' @param valueProperty The property to use for coloring
#' @param scale The scale to use from chroma.js
#' @param steps number of breakes
#' @param mode q for quantile, e for equidistant, k for k-means
#' @param channelMode Default "rgb", can be one of "rgb", "lab", "hsl", "lch"
#' @param padding either a single number or a 2 number vector for clipping color values at ends.
#' @param correctLightness whether to correct lightness
#' @param bezierInterpolate whether to use bezier interpolate for determining colors
#' @param colors overrides scale with manual colors
#' @param legendOptions Options to show a legend.
#' @rdname omnivore
#' @export
#' @examples
#' ## addGeoJSONChoropleth
#' \donttest{
#' geoJson <- readr::read_file(
#'   "https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson"
#' )
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(-77.0369, 38.9072, 11) %>%
#'   addBootstrapDependency() %>%
#'   enableMeasurePath() %>%
#'   addGeoJSONChoropleth(
#'     geoJson,
#'     valueProperty = "AREASQMI",
#'     scale = c("white", "red"),
#'     mode = "q",
#'     steps = 4,
#'     padding = c(0.2, 0),
#'     labelProperty = "NAME",
#'     popupProperty = propstoHTMLTable(
#'       props = c("NAME", "AREASQMI", "REP_NAME", "WEB_URL", "REP_PHONE", "REP_EMAIL", "REP_OFFICE"),
#'       table.attrs = list(class = "table table-striped table-bordered"),
#'       drop.na = TRUE
#'     ),
#'     color = "#ffffff", weight = 1, fillOpacity = 0.7,
#'     highlightOptions = highlightOptions(
#'       weight = 2, color = "#000000",
#'       fillOpacity = 1, opacity = 1,
#'       bringToFront = TRUE, sendToBack = TRUE
#'     ),
#'     pathOptions = pathOptions(
#'       showMeasurements = TRUE,
#'       measurementOptions = measurePathOptions(imperial = TRUE)
#'     )
#'   )
#' }
#'
#' ## for more examples see
#' # browseURL(system.file("examples/geojsonv2.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/measurePath.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/search.R", package = "leaflet.extras"))
#' # browseURL(system.file("examples/TopoJSON.R", package = "leaflet.extras"))
#'
addGeoJSONChoropleth <- function(
    map, geojson, layerId = NULL, group = NULL,
    valueProperty,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    scale = c("white", "red"),
    steps = 5,
    mode = "q",
    channelMode = c("rgb", "lab", "hsl", "lch"),
    padding = NULL,
    correctLightness = FALSE,
    bezierInterpolate = FALSE,
    colors = NULL,
    stroke = TRUE,
    color = "#03F",
    weight = 1,
    opacity = 0.5,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL,
    legendOptions = NULL) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(
    map$dependencies,
    geoJSONChoroplethDependency()
  )

  channelMode <- match.arg(channelMode)

  pathOptions <- c(pathOptions, list(
    valueProperty = valueProperty,
    scale = scale,
    steps = steps,
    mode = mode,
    channelMode = channelMode,
    padding = padding,
    correctLightness = correctLightness,
    bezierInterpolate = bezierInterpolate,
    colors = colors,
    stroke = stroke,
    color = color,
    weight = weight,
    opacity = opacity,
    fillOpacity = fillOpacity,
    dashArray = dashArray,
    smoothFactor = smoothFactor,
    noClip = noClip
  ))
  leaflet::invokeMethod(
    map, leaflet::getMapData(map), "addGeoJSONChoropleth",
    geojson, layerId, group,
    labelProperty, labelOptions, popupProperty, popupOptions,
    pathOptions, highlightOptions, legendOptions
  )
}

#' Adds a KML to the leaflet map.
#' @param kml a KML URL or contents in a character vector.
#' @rdname omnivore
#' @export
#' @examples
#' ## addKML
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
addKML <- function(
    map, kml, layerId = NULL, group = NULL,
    markerType = NULL, markerIcons = NULL,
    markerIconProperty = NULL, markerOptions = leaflet::markerOptions(),
    clusterOptions = NULL, clusterId = NULL,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    fill = TRUE,
    fillColor = color,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL) {
  invokeJSAddMethod(
    "addKML",
    map, kml, layerId, group,
    markerType, markerIcons,
    markerIconProperty, markerOptions,
    clusterOptions, clusterId,
    labelProperty, labelOptions, popupProperty, popupOptions,
    stroke,
    color,
    weight,
    opacity,
    fill,
    fillColor,
    fillOpacity,
    dashArray,
    smoothFactor,
    noClip,
    pathOptions, highlightOptions
  )
}

#' Adds a KML Choropleth.
#' @rdname omnivore
#' @export
#' @examples
#' ## addKMLChoropleth
#' \donttest{
#' kml <- readr::read_file(
#'   system.file("examples/data/kml/cb_2015_us_state_20m.kml.zip", package = "leaflet.extras")
#' )
#'
#' leaflet() %>%
#'   addBootstrapDependency() %>%
#'   setView(-98.583333, 39.833333, 4) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addKMLChoropleth(
#'     kml,
#'     valueProperty = JS(
#'       "function(feature){
#'          var props = feature.properties;
#'          var aland = props.ALAND/100000;
#'          var awater = props.AWATER/100000;
#'          return 100*awater/(awater+aland);
#'       }"
#'     ),
#'     scale = "OrRd", mode = "q", steps = 5,
#'     padding = c(0.2, 0),
#'     popupProperty = "description",
#'     labelProperty = "NAME",
#'     color = "#ffffff", weight = 1, fillOpacity = 1,
#'     highlightOptions = highlightOptions(
#'       fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
#'       bringToFront = TRUE, sendToBack = TRUE
#'     ),
#'     legendOptions = legendOptions(
#'       title = "% of Water Area",
#'       numberFormatOptions = list(
#'         style = "decimal",
#'         maximumFractionDigits = 2
#'       )
#'     )
#'   )
#' }
#'
addKMLChoropleth <- function(
    map, kml, layerId = NULL, group = NULL,
    valueProperty,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    scale = c("white", "red"),
    steps = 5,
    mode = "q",
    channelMode = c("rgb", "lab", "hsl", "lch"),
    padding = NULL,
    correctLightness = FALSE,
    bezierInterpolate = FALSE,
    colors = NULL,
    stroke = TRUE,
    color = "#03F",
    weight = 1,
    opacity = 0.5,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL,
    legendOptions = NULL) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(
    map$dependencies,
    geoJSONChoroplethDependency()
  )
  channelMode <- match.arg(channelMode)
  pathOptions <- c(pathOptions, list(
    valueProperty = valueProperty,
    scale = scale,
    steps = steps,
    mode = mode,
    channelMode = channelMode,
    padding = padding,
    correctLightness = correctLightness,
    bezierInterpolate = bezierInterpolate,
    colors = colors,
    stroke = stroke,
    color = color,
    weight = weight,
    opacity = opacity,
    fillOpacity = fillOpacity,
    dashArray = dashArray,
    smoothFactor = smoothFactor,
    noClip = noClip
  ))
  leaflet::invokeMethod(
    map, leaflet::getMapData(map), "addKMLChoropleth",
    kml, layerId, group,
    labelProperty, labelOptions, popupProperty, popupOptions,
    pathOptions, highlightOptions, legendOptions
  )
}

#' Options for parsing CSV
#' @param latfield field name for latitude
#' @param lonfield field name for longitude
#' @param delimiter field separator
#' @rdname omnivore
#' @export
csvParserOptions <- function(
    latfield,
    lonfield,
    delimiter = ",") {
  list(
    latfield = latfield,
    lonfield = lonfield,
    delimiter = delimiter
  )
}

#' Adds a CSV to the leaflet map.
#' @param csv a CSV URL or contents in a character vector.
#' @param csvParserOptions options for parsing the CSV.
#' Use \code{\link{csvParserOptions}}() to supply csv parser options.
#' @rdname omnivore
#' @export
#' @examples
#' ## addCSV
#' \donttest{
#' csv <- readr::read_file(
#'   system.file("examples/data/csv/world_airports.csv.zip", package = "leaflet.extras")
#' )
#'
#' leaflet() %>%
#'   setView(0, 0, 2) %>%
#'   addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%
#'   addCSV(
#'     csv,
#'     csvParserOptions("latitude_deg", "longitude_deg"),
#'     markerType = "circleMarker",
#'     stroke = FALSE, fillColor = "red", fillOpacity = 1,
#'     markerOptions = markerOptions(radius = 0.5)
#'   )
#' }
#'
addCSV <- function(
    map, csv, csvParserOptions, layerId = NULL, group = NULL,
    markerType = NULL, markerIcons = NULL,
    markerIconProperty = NULL, markerOptions = leaflet::markerOptions(),
    clusterOptions = NULL, clusterId = NULL,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    fill = TRUE,
    fillColor = color,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL) {
  invokeJSAddMethod(
    "addCSV",
    map, csv, layerId, group,
    markerType, markerIcons,
    markerIconProperty, markerOptions,
    clusterOptions, clusterId,
    labelProperty, labelOptions, popupProperty, popupOptions,
    stroke,
    color,
    weight,
    opacity,
    fill,
    fillColor,
    fillOpacity,
    dashArray,
    smoothFactor,
    noClip,
    pathOptions, highlightOptions, csvParserOptions
  )
}

#' Adds a GPX to the leaflet map.
#' @param gpx a GPX URL or contents in a character vector.
#' @rdname omnivore
#' @export
#' @examples
#' ## addGPX
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
#'   addWebGLGPXHeatmap(airports, size = 20000, group = "airports", opacity = 0.9) %>%
#'   addGPX(
#'     airports,
#'     markerType = "circleMarker",
#'     stroke = FALSE, fillColor = "black", fillOpacity = 1,
#'     markerOptions = markerOptions(radius = 1.5),
#'     group = "airports"
#'   )
#' }
#'
#' ## for a larger example see
#' # browseURL(system.file("examples/GPX.R", package = "leaflet.extras"))
#'
addGPX <- function(
    map, gpx, layerId = NULL, group = NULL,
    markerType = NULL, markerIcons = NULL,
    markerIconProperty = NULL, markerOptions = leaflet::markerOptions(),
    clusterOptions = NULL, clusterId = NULL,
    labelProperty = NULL, labelOptions = leaflet::labelOptions(),
    popupProperty = NULL, popupOptions = leaflet::popupOptions(),
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    fill = TRUE,
    fillColor = color,
    fillOpacity = 0.2,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    pathOptions = leaflet::pathOptions(),
    highlightOptions = NULL) {
  invokeJSAddMethod(
    "addGPX",
    map, gpx, layerId, group,
    markerType, markerIcons,
    markerIconProperty, markerOptions,
    clusterOptions, clusterId,
    labelProperty, labelOptions, popupProperty, popupOptions,
    stroke,
    color,
    weight,
    opacity,
    fill,
    fillColor,
    fillOpacity,
    dashArray,
    smoothFactor,
    noClip,
    pathOptions, highlightOptions
  )
}
