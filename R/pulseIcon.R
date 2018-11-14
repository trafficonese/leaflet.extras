
pulseIconDependency <- function() {
  list(
    # // "leaflet-pulse-icon": "0.1.0",
    html_dep_prod("lfx-pulse-icon", "0.1.0", has_style = TRUE, has_binding = TRUE)
  )
}


#' Make pulse-icon set
#'
#' @param ... icons created from \code{\link{makePulseIcon}()}
#' @rdname pulseMarkers
#' @export
#' @examples
#'
#' iconSet = pulseIconList(
#'   red = makePulseIcon(color = "#ff0000"),
#'   blue = makePulseIcon(color = "#0000ff")
#' )
#'
#' iconSet[c("red", "blue")]
#'
pulseIconList = function(...) {
  res = structure(
    list(...),
    class = "leaflet_pulse_icon_set"
  )
  cls = unlist(lapply(res, inherits, "leaflet_pulse_icon"))
  if (any(!cls))
    stop("Arguments passed to pulseIconList() must be icon objects returned from makePulseIcon()")
  res
}

#' @param x icons
#' @param i offset
#' @export
#' @rdname pulseMarkers
`[.leaflet_pulse_icon_set` = function(x, i) {
  if (is.factor(i)) {
    i = as.character(i)
  }

  if (!is.character(i) && !is.numeric(i) && !is.integer(i)) {
    stop("Invalid subscript type '", typeof(i), "'")
  }

  structure(.subset(x, i), class = "leaflet_pulse_icon_set")
}

pulseIconSetToPulseIcons = function(x) {
  cols = names(formals(makePulseIcon))
  cols = structure(as.list(cols), names = cols)

  # Construct an equivalent output to pulseIcons().
  leaflet::filterNULL(lapply(cols, function(col) {
    # Pluck the `col` member off of each item in pulseIconObjs and put them in an
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

#' Make Pulse Icon
#'
#' @inheritParams pulseIcons
#' @export
#' @rdname pulseMarkers
makePulseIcon <- function(
  color = "#ff0000",
  iconSize = 12,
  animate = TRUE,
  heartbeat = 1
) {

  icon = leaflet::filterNULL(list(
    color = color, iconSize = iconSize, animate = animate, heartbeat = heartbeat
  ))
  structure(icon, class = "leaflet_pulse_icon")
}

#' Create a list of pulse icon data see
#' \url{https://github.com/mapshakers/leaflet-icon-pulse}
#'
#' An icon can be represented as a list of the form \code{list(color, iconSize,
#' ...)}. This function is vectorized over its arguments to create a list of
#' icon data. Shorter argument values will be re-cycled. \code{NULL} values for
#' these arguments will be ignored.
#' @param color Color of the icon
#' @param iconSize Size of Icon in Pixels.
#' @param animate To animate the icon or not, defaults to TRUE.
#' @param heartbeat Interval between each pulse in seconds.
#' @export
#' @rdname pulseMarkers
pulseIcons <- function(
  color = "#ff0000",
  iconSize = 12,
  animate = TRUE,
  heartbeat = 1
) {

  leaflet::filterNULL(list(
    color = color, iconSize = iconSize, animate = animate, heartbeat = heartbeat
  ))
}

#' Add Pulse Markers
#' @param map the map to add pulse Markers to.
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
#' @rdname pulseMarkers
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addPulseMarkers(
#'     lng = -118.456554, lat = 34.078039,
#'     label = "This is a label",
#'     icon = makePulseIcon(heartbeat = 0.5)
#'   )
#'
#'
#' ## for more examples see
#' # browseURL(system.file("examples/pulseIcon.R", package = "leaflet.extras"))
addPulseMarkers = function(
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
                        pulseIconDependency())

  if (!is.null(icon)) {
    # If formulas are present, they must be evaluated first so we can pack the
    # resulting values
    icon = leaflet::evalFormula(list(icon), data)[[1]]

    if (inherits(icon, "leaflet_pulse_icon_set")) {
      icon = pulseIconSetToPulseIcons(icon)
    }
    icon = leaflet::filterNULL(icon)
  }

  if (!is.null(clusterOptions))
    map$dependencies = c(map$dependencies, leaflet::leafletDependencies$markerCluster())

  pts = leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addPulseMarkers")
  leaflet::invokeMethod(
    map, data, "addPulseMarkers", pts$lat, pts$lng, icon, layerId,
    group, options, popup, popupOptions,
    clusterOptions, clusterId, leaflet::safeLabel(label, data), labelOptions
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}
