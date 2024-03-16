weatherIconDependency <- function() {
  list(
    # napa tallsam/Leaflet.weather-markers#afda5b3
    html_dep_prod("lfx-weather-markers", "3.0.0", has_style = TRUE, has_binding = TRUE)
  )
}

# These are the only colors supported for the marker as per the CSS.
markerColors <- c("red", "darkred", "lightred", "orange", "beige", "green", "darkgreen", "lightgreen", "blue", "darkblue", "lightblue", "purple", "darkpurple", "pink", "cadetblue", "white", "gray", "lightgray", "black")

#' Make weather-icon set
#'
#' @param ... icons created from \code{\link{makeWeatherIcon}()}
#' @rdname weatherMarkers
#' @export
#' @examples
#'
#' iconSet <- weatherIconList(
#'   hurricane = makeWeatherIcon(icon = "hurricane"),
#'   tornado = makeWeatherIcon(icon = "tornado")
#' )
#'
#' iconSet[c("hurricane", "tornado")]
weatherIconList <- function(...) {
  res <- structure(
    list(...),
    class = "leaflet_weather_icon_set"
  )
  cls <- unlist(lapply(res, inherits, "leaflet_weather_icon"))
  if (any(!cls)) {
    stop("Arguments passed to weatherIconList() must be icon objects returned from makeWeatherIcon()")
  }
  res
}

#' @param x icons
#' @param i offset
#' @export
#' @rdname weatherMarkers
`[.leaflet_weather_icon_set` <- function(x, i) {
  if (is.factor(i)) {
    i <- as.character(i)
  }

  if (!is.character(i) && !is.numeric(i) && !is.integer(i)) {
    stop("Invalid subscript type '", typeof(i), "'")
  }

  structure(.subset(x, i), class = "leaflet_weather_icon_set")
}

weatherIconSetToWeatherIcons <- function(x) {
  cols <- names(formals(makeWeatherIcon))
  cols <- structure(as.list(cols), names = cols)

  # Construct an equivalent output to weatherIcons().
  leaflet::filterNULL(lapply(cols, function(col) {
    # Pluck the `col` member off of each item in weatherIconObjs and put them in an
    # unnamed list (or vector if possible).
    colVals <- unname(sapply(x, `[[`, col))

    # If this is the common case where there's lots of values but they're all
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

#' Make Weather Icon
#'
#' @inheritParams weatherIcons
#' @export
#' @rdname weatherMarkers
makeWeatherIcon <- function(
    icon,
    markerColor = "red",
    iconColor = "white",
    # iconSize = c(35, 45),
    # iconAnchor =   c(17, 42),
    # popupAnchor = c(1, -32),
    # shadowAnchor = c(10, 12),
    # shadowSize = c(36, 16),
    # className = "weather-marker",
    # prefix = "wi",
    extraClasses = NULL) {
  if (!markerColor %in% markerColors) {
    stop(sprintf("markerColor should be one of %s", paste(markerColors, collapse = ", ")))
  }

  icon <- leaflet::filterNULL(list(
    icon = icon, markerColor = markerColor,
    iconColor = iconColor, extraClasses = extraClasses
  ))
  structure(icon, class = "leaflet_weather_icon")
}

#' Create a list of weather icon data see
#' \url{https://github.com/mapshakers/leaflet-icon-weather}
#'
#' An icon can be represented as a list of the form \code{list(icon, markerColor,
#' ...)}. This function is vectorized over its arguments to create a list of
#' icon data. Shorter argument values will be re-cycled. \code{NULL} values for
#' these arguments will be ignored.
#' @param icon the weather icon name w/o the "wi-" prefix. For a full list see \url{https://erikflowers.github.io/weather-icons/}
#' @param markerColor color of the marker
#' @param iconColor color of the weather icon
#' @param extraClasses Character vector of extra classes.
#' @export
#' @rdname weatherMarkers
weatherIcons <- function(
    icon,
    markerColor = "red",
    iconColor = "white",
    # iconSize = c(35, 45),
    # iconAnchor =   c(17, 42),
    # popupAnchor = c(1, -32),
    # shadowAnchor = c(10, 12),
    # shadowSize = c(36, 16),
    # className = "weather-marker",
    # prefix = "wi",
    extraClasses = NULL) {
  if (!any(markerColor %in% markerColors)) {
    stop(sprintf("markerColor should be one of %s", paste(markerColors, collapse = ", ")))
  }

  leaflet::filterNULL(list(
    icon = icon, markerColor = markerColor,
    iconColor = iconColor, extraClasses = extraClasses
  ))
}

#' Add Weather Markers
#' @inheritParams leaflet::addMarkers
#' @rdname weatherMarkers
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addWeatherMarkers(
#'     lng = -118.456554, lat = 34.078039,
#'     label = "This is a label",
#'     icon = makeWeatherIcon(
#'       icon = "hot",
#'       iconColor = "#ffffff77",
#'       markerColor = "blue"
#'     )
#'   )
#'
#' ## for more examples see
#' # browseURL(system.file("examples/weatherIcons.R", package = "leaflet.extras"))
addWeatherMarkers <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
    icon = NULL,
    popup = NULL,
    popupOptions = NULL,
    label = NULL,
    labelOptions = NULL,
    options = leaflet::markerOptions(),
    clusterOptions = NULL,
    clusterId = NULL,
    data = leaflet::getMapData(map)) {
  map$dependencies <- c(
    map$dependencies,
    weatherIconDependency()
  )

  if (!is.null(icon)) {
    # If formulas are present, they must be evaluated first so we can pack the
    # resulting values
    icon <- leaflet::evalFormula(list(icon), data)[[1]]

    if (inherits(icon, "leaflet_weather_icon_set")) {
      icon <- weatherIconSetToWeatherIcons(icon)
    }
    icon <- leaflet::filterNULL(icon)
  }

  if (!is.null(clusterOptions)) {
    map$dependencies <- c(map$dependencies, leaflet::leafletDependencies$markerCluster())
  }

  pts <- leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addWeatherMarkers"
  )
  leaflet::invokeMethod(
    map, data, "addWeatherMarkers", pts$lat, pts$lng, icon, layerId,
    group, options, popup, popupOptions,
    clusterOptions, clusterId, leaflet::safeLabel(label, data), labelOptions
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}
