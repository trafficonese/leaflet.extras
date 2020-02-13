
mapkeyIconDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-mapkeyicon", version = "1.0.0",
      src = system.file("htmlwidgets/build/lfx-mapkeyicon", package = "leaflet.extras"),
      script = c("L.Icon.Mapkey.js",
                 "lfx-mapkeyicon-bindings.js"),
      stylesheet = c("L.Icon.Mapkey.css"),
      all_files = TRUE
    )
  )
}


#' Make mapkey-icon set
#'
#' @param ... icons created from \code{\link{makeMapkeyIcon}()}
#' @family mapkeyMarkers
#' @export
#' @examples
#'
#' iconSet = mapkeyIconList(
#'   red = makeMapkeyIcon(color = "#ff0000"),
#'   blue = makeMapkeyIcon(color = "#0000ff")
#' )
#'
#' iconSet[c("red", "blue")]
#'
mapkeyIconList = function(...) {
  res = structure(
    list(...),
    class = "leaflet_mapkey_icon_set"
  )
  cls = unlist(lapply(res, inherits, "leaflet_mapkey_icon"))
  if (any(!cls))
    stop("Arguments passed to mapkeyIconList() must be icon objects returned from makeMapkeyIcon()")
  res
}

#' leaflet_mapkey_icon_set
#' @param x icons
#' @param i offset
#' @export
#' @family mapkeyMarkers
`[.leaflet_mapkey_icon_set` = function(x, i) {
  if (is.factor(i)) {
    i = as.character(i)
  }

  if (!is.character(i) && !is.numeric(i) && !is.integer(i)) {
    stop("Invalid subscript type '", typeof(i), "'")
  }

  structure(.subset(x, i), class = "leaflet_mapkey_icon_set")
}

mapkeyIconSetToMapkeyIcons = function(x) {
  cols = names(formals(makeMapkeyIcon))
  cols = structure(as.list(cols), names = cols)

  # Construct an equivalent output to mapkeyIcons().
  leaflet::filterNULL(lapply(cols, function(col) {
    # Pluck the `col` member off of each item in mapkeyIconObjs and put them in an
    # unnamed list (or vector if possible).
    colVals = unname(sapply(x, `[[`, col))

    # If this is the common case where there"s lots of values but they"re all
    # actually the same exact thing, then just return one value; this will be
    # much cheaper to send to the client, and we'll do recycling on the client
    # side anyway.
    if (length(unique(colVals)) == 1) {
      return(colVals[[1]])
    } else {
      return(colVals)
    }
  }))
}

#' Make mapkey Icon
#'
#' @inheritParams mapkeyIcons
#' @export
#' @family mapkeyMarkers
makeMapkeyIcon <- function(
  icon = 'mapkey',
  color = "#ff0000",
  iconSize = 12,
  background = '#1F7499',
  borderRadius = '100%',
  hoverScale = 1.4,
  hoverEffect = TRUE,
  additionalCSS = NULL,
  hoverCSS = NULL,
  htmlCode = NULL,
  boxShadow = TRUE
) {
  icon = leaflet::filterNULL(list(
    icon = icon,
    color = color,
    size = iconSize,
    background = background,
    borderRadius = borderRadius,
    hoverScale = hoverScale,
    hoverEffect = hoverEffect,
    additionalCSS = additionalCSS,
    hoverCSS = hoverCSS,
    htmlCode = htmlCode,
    boxShadow = boxShadow
  ))
  structure(icon, class = "leaflet_mapkey_icon")
}

#' Create a list of mapkey icon data see
#' \url{https://github.com/mapshakers/leaflet-icon-mapkey}
#'
#' An icon can be represented as a list of the form \code{list(color, iconSize,
#' ...)}. This function is vectorized over its arguments to create a list of
#' icon data. Shorter argument values will be re-cycled. \code{NULL} values for
#' these arguments will be ignored.
#' @param icon ID of the mapkey Icon you want to use. See
#'   \href{http://mapkeyicons.com/}{mapkeyicons.com} for a full list.
#' @param color Any CSS color (e.g. 'red','rgba(20,160,90,0.5)', '#686868', ...)
#' @param iconSize Size of Icon in Pixels. Default is 12
#' @param background Any CSS color or false for no background
#' @param borderRadius Any number (for circle size/2, for square 0.001)
#' @param hoverScale Any real number (best result in range 1 - 2, use 1 for no effect)
#' @param hoverEffect Switch on/off effect on hover
#' @param hoverCSS CSS code (e.g. "background-color:#992b00!important; color:#99defc!important;")
#' @param additionalCSS CSS code (e.g. "border:4px solid #aa3838;")
#' @param htmlCode e.g. '&#57347;&#xe003;'.
#'   See \href{http://mapkeyicons.com/}{mapkeyicons.com} for further information
#' @param boxShadow Should a shadow be visible.
#' @export
#' @family mapkeyMarkers
#' @examples \dontrun{
#' makeMapkeyIcon(icon = "traffic_signal",
#'                color = "#0000ff",
#'                iconSize = 12,
#'                boxShadow = FALSE,
#'                background="transparent")
#' }
mapkeyIcons <- function(
  icon = 'mapkey',
  color = "#ff0000",
  iconSize = 12,
  background = '#1F7499',
  borderRadius = '100%',
  hoverScale = 1.4,
  hoverEffect = TRUE,
  hoverCSS = NULL,
  additionalCSS = NULL,
  htmlCode = NULL,
  boxShadow = TRUE
) {
  leaflet::filterNULL(list(
    icon = icon,
    color = color,
    size = iconSize,
    background = background,
    borderRadius = borderRadius,
    hoverScale = hoverScale,
    hoverEffect = hoverEffect,
    hoverCSS = hoverCSS,
    additionalCSS = additionalCSS,
    htmlCode = htmlCode,
    boxShadow = boxShadow
  ))
}

#' Add mapkey Markers
#' @param map the map to add mapkey Markers to.
#' @param lng a numeric vector of longitudes, or a one-sided formula of the form
#'   \code{~x} where \code{x} is a variable in \code{data}; by default (if not
#'   explicitly provided), it will be automatically inferred from \code{data} by
#'   looking for a column named \code{lng}, \code{long}, or \code{longitude}
#'   (case-insensitively)
#' @param lat a vector of latitudes or a formula (similar to the \code{lng}
#'   argument; the names \code{lat} and \code{latitude} are used when guessing
#'   the latitude column from \code{data})
#' @param popup a character vector of the HTML content for the popups (you are
#'   recommended to escape the text using \code{\link[htmltools]{htmlEscape}()}
#'   for security reasons)
#' @param popupOptions options for popup
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{\link{clearGroup}} and \code{\link{addLayersControl}} purposes).
#'   Human-friendly group names are permitted--they need not be short,
#'   identifier-style names. Any number of layers and even different types of
#'   layers (e.g. markers and polygons) can share the same group name.
#' @param data the data object from which the argument values are derived; by
#'   default, it is the \code{data} object provided to \code{leaflet()}
#'   initially, but can be overridden
#' @param icon the icon(s) for markers;
#' @param label a character vector of the HTML content for the labels
#' @param labelOptions A Vector of \code{\link{labelOptions}} to provide label
#' options for each label. Default \code{NULL}
#' @param clusterOptions if not \code{NULL}, markers will be clustered using
#'   \href{https://github.com/Leaflet/Leaflet.markercluster}{Leaflet.markercluster};
#'    you can use \code{\link{markerClusterOptions}()} to specify marker cluster
#'   options
#' @param clusterId the id for the marker cluster layer
#' @param options a list of extra options for tile layers, popups, paths
#'   (circles, rectangles, polygons, ...), or other map elements
#' @family mapkeyMarkers
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addMapkeyMarkers(
#'     lng = -118.456554, lat = 34.078039,
#'     label = "This is a label",
#'     icon = makeMapkeyIcon(icon = "school")
#'   )
#'
#' ## for more examples see
#' # browseURL(system.file("examples/mapkeyIcons.R", package = "leaflet.extras"))
addMapkeyMarkers = function(
  map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
  icon = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = leaflet::markerOptions(),
  clusterOptions = NULL,
  clusterId = NULL,
  data = leaflet::getMapData(map)
) {
  map$dependencies <- c(map$dependencies,
                        mapkeyIconDependency())

  if (!is.null(icon)) {
    # If formulas are present, they must be evaluated first so we can pack the
    # resulting values
    icon = leaflet::evalFormula(list(icon), data)[[1]]

    if (inherits(icon, "leaflet_mapkey_icon_set")) {
      icon = mapkeyIconSetToMapkeyIcons(icon)
    }
    icon = leaflet::filterNULL(icon)
  }

  if (!is.null(clusterOptions))
    map$dependencies = c(map$dependencies, leaflet::leafletDependencies$markerCluster())

  pts = leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addMapkeyMarkers")
  leaflet::invokeMethod(
    map, data, "addMapkeyMarkers", pts$lat, pts$lng, icon, layerId,
    group, options, popup, popupOptions,
    clusterOptions, clusterId, leaflet::safeLabel(label, data), labelOptions
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}
