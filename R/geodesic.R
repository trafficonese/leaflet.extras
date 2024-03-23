geodesicDependencies <- function() {
  list(
    # // "Leaflet.geodesic": "2.7.1",
    html_dep_prod("lfx-geodesic", "2.7.1", has_binding = TRUE)
  )
}

#' Add Geodesic Lines & Circles
#'
#' @description
#' A geodesic line is the shortest path between two given positions on the
#' earth surface. It's based on Vincenty's formulae implemented by
#' \href{https://github.com/chrisveness/geodesy}{Chris Veness} for highest precision.
#' @name geodesics
NULL


#' addGeodesicPolylines
#' @param steps Defines how many intermediate points are generated along the path.
#'   More steps mean a smoother path.
#' @param wrap Wrap line at map border (date line). Set to "false" if you want
#'   lines to cross the dateline (experimental, see noWrap-example on how to use)
#' @param showMarker Should the nodes/center points be visualized as Markers?
#' @param showStats This will create an L.Control with some information on the geodesics
#' @param statsFunction A custom JS function to be showed in the info control
#' @param markerOptions List of options for the markers. See \code{\link[leaflet]{markerOptions}}
#' @inheritParams leaflet::addPolylines
#' @export
#' @rdname geodesics
#' @examples
#' berlin <- c(52.51, 13.4)
#' losangeles <- c(34.05, -118.24)
#' santiago <- c(-33.44, -70.71)
#' tokio <- c(35.69, 139.69)
#' sydney <- c(-33.91, 151.08)
#' capetown <- c(-33.91, 18.41)
#' calgary <- c(51.05, -114.08)
#' hammerfest <- c(70.67, 23.68)
#' barrow <- c(71.29, -156.76)
#'
#' df <- as.data.frame(rbind(hammerfest, calgary, losangeles, santiago, capetown, tokio, barrow))
#' names(df) <- c("lat", "lng")
#'
#' leaflet(df) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addGeodesicPolylines(
#'     lng = ~lng, lat = ~lat, weight = 2, color = "red",
#'     steps = 50, opacity = 1
#'   ) %>%
#'   addCircleMarkers(df,
#'     lat = ~lat, lng = ~lng, radius = 3, stroke = FALSE,
#'     fillColor = "black", fillOpacity = 1
#'   )
#'
#' ## for more examples see
#' # browseURL(system.file("examples/geodesic.R", package = "leaflet.extras"))
addGeodesicPolylines <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
    steps = 10,
    wrap = TRUE,
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    popup = NULL,
    popupOptions = NULL,
    label = NULL,
    labelOptions = NULL,
    options = pathOptions(),
    highlightOptions = NULL,
    icon = NULL,
    showMarker = FALSE,
    showStats = FALSE,
    statsFunction = NULL,
    markerOptions = NULL,
    data = getMapData(map)) {
  map$dependencies <- c(map$dependencies, geodesicDependencies())

  options <- c(options, list(
    steps = steps, wrap = wrap,
    stroke = stroke, color = color, weight = weight, opacity = opacity,
    dashArray = dashArray, smoothFactor = smoothFactor, noClip = noClip,
    showStats = showStats, statsFunction = statsFunction,
    showMarker = showMarker
  ))

  if (!is.null(icon)) {
    # If formulas are present, they must be evaluated first so we can pack the
    # resulting values
    icon <- leaflet::evalFormula(list(icon), data)[[1]]

    if (inherits(icon, "leaflet_icon_set")) {
      icon <- iconSetToIcons(icon)
    } else if (inherits(icon, "leaflet_awesome_icon_set") || inherits(icon, "leaflet_awesome_icon")) {
      if (inherits(icon, "leaflet_awesome_icon_set")) {
        libs <- unique(unlist(lapply(icon, function(x) x[["library"]])))
        map <- addAwesomeMarkersDependencies(map, libs)
        icon <- awesomeIconSetToAwesomeIcons(icon)
      } else {
        map <- addAwesomeMarkersDependencies(map, icon$library)
      }
      icon$awesomemarker <- TRUE
    } else {
      icon$iconUrl <- b64EncodePackedIcons(packStrings(icon$iconUrl))
      icon$iconRetinaUrl <- b64EncodePackedIcons(packStrings(icon$iconRetinaUrl))
      icon$shadowUrl <- b64EncodePackedIcons(packStrings(icon$shadowUrl))
      icon$shadowRetinaUrl <- b64EncodePackedIcons(packStrings(icon$shadowRetinaUrl))
      if (length(icon$iconSize) == 2) {
        if (is.numeric(icon$iconSize[[1]]) && is.numeric(icon$iconSize[[2]])) {
          icon$iconSize <- list(icon$iconSize)
        }
      }
    }

    icon <- leaflet::filterNULL(icon)
  }

  pgons <- leaflet::derivePolygons(
    data, lng, lat, missing(lng), missing(lat), "addGeodesicPolylines"
  )
  leaflet::invokeMethod(
    map, data, "addGeodesicPolylines", pgons, layerId, group, options, icon,
    popup, popupOptions, safeLabel(label, data), labelOptions, highlightOptions,
    markerOptions
  ) %>%
    leaflet::expandLimitsBbox(pgons)
}


#' @export
#' @rdname geodesics
#' @description Add Lat/Long to a Geodesic Polyline.
#' @param lat,lng lat/lng to add to the Geodesic
addLatLng <- function(map, lat, lng, layerId = NULL) {
  leaflet::invokeMethod(map, NULL, "addLatLng", lat, lng, layerId)
}


#' @export
#' @rdname geodesics
#' @description Adds a Great Circle to the map.
#' @param lat_center,lng_center lat/lng for the center
#' @param radius in meters
#' @inheritParams addGeodesicPolylines
addGreatCircles <- function(
    map, lat_center = NULL, lng_center = NULL, radius, layerId = NULL, group = NULL,
    steps = 10,
    wrap = TRUE,
    stroke = TRUE,
    color = "#03F",
    weight = 5,
    opacity = 0.5,
    dashArray = NULL,
    smoothFactor = 1.0,
    noClip = FALSE,
    popup = NULL,
    popupOptions = NULL,
    label = NULL,
    labelOptions = NULL,
    options = pathOptions(),
    highlightOptions = NULL,
    icon = NULL,
    fill = TRUE,
    showMarker = FALSE,
    showStats = FALSE,
    statsFunction = NULL,
    markerOptions = NULL,
    data = getMapData(map)) {
  map$dependencies <- c(map$dependencies, geodesicDependencies())

  if (!is.null(icon)) {
    # If formulas are present, they must be evaluated first so we can pack the
    # resulting values
    icon <- leaflet::evalFormula(list(icon), data)[[1]]

    if (inherits(icon, "leaflet_icon_set")) {
      icon <- iconSetToIcons(icon)
    } else if (inherits(icon, "leaflet_awesome_icon_set") || inherits(icon, "leaflet_awesome_icon")) {
      if (inherits(icon, "leaflet_awesome_icon_set")) {
        libs <- unique(unlist(lapply(icon, function(x) x[["library"]])))
        map <- addAwesomeMarkersDependencies(map, libs)
        icon <- awesomeIconSetToAwesomeIcons(icon)
      } else {
        map <- addAwesomeMarkersDependencies(map, icon$library)
      }
      icon$awesomemarker <- TRUE
    } else {
      icon$iconUrl <- b64EncodePackedIcons(packStrings(icon$iconUrl))
      icon$iconRetinaUrl <- b64EncodePackedIcons(packStrings(icon$iconRetinaUrl))
      icon$shadowUrl <- b64EncodePackedIcons(packStrings(icon$shadowUrl))
      icon$shadowRetinaUrl <- b64EncodePackedIcons(packStrings(icon$shadowRetinaUrl))
      if (length(icon$iconSize) == 2) {
        if (is.numeric(icon$iconSize[[1]]) && is.numeric(icon$iconSize[[2]])) {
          icon$iconSize <- list(icon$iconSize)
        }
      }
    }

    icon <- leaflet::filterNULL(icon)
  }

  options <- c(options, list(
    steps = steps, wrap = wrap,
    stroke = stroke, color = color, weight = weight, opacity = opacity,
    dashArray = dashArray, smoothFactor = smoothFactor, noClip = noClip,
    fill = fill, showStats = showStats, statsFunction = statsFunction,
    showMarker = showMarker
  ))
  points <- leaflet::derivePoints(
    data, lng_center, lat_center, missing(lng_center), missing(lat_center),
    "addGreatCircles"
  )
  leaflet::invokeMethod(
    map, data, "addGreatCircles", points$lat, points$lng, radius, layerId, group, options, icon,
    popup, popupOptions, safeLabel(label, data), labelOptions, highlightOptions, markerOptions
  ) %>%
    leaflet::expandLimits(points$lat, points$lng)
}
