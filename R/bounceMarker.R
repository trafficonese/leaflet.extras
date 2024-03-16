# Source: https://github.com/maximeh/leaflet.bouncemarker
bounceMarkerDependency <- function() {
  list(
    # // "leaflet.BounceMarker": "github:maximeh/leaflet.bouncemarker#v1.1",
    # bounce bindings
    html_dep_prod("lfx-bouncemarker", "1.1.0", has_binding = TRUE)
  )
}

#' Add Bounce Markers to map
#' @inheritParams leaflet::addMarkers
#' @param duration integer scalar: The duration of the animation in milliseconds.
#' @param height integer scalar: Height at which the marker is dropped.
#' @md
#' @author Markus Dumke
#' @export
#' @seealso [GitHub: leaflet.bouncemarker](https://github.com/maximeh/leaflet.bouncemarker)
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addBounceMarkers(49, 11)
addBounceMarkers <- function(map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
                             icon = NULL,
                             duration = 1000, height = 100,
                             popup = NULL,
                             popupOptions = NULL,
                             label = NULL,
                             labelOptions = NULL,
                             options = leaflet::markerOptions(),
                             # clusterOptions = NULL,
                             # clusterId = NULL,
                             data = leaflet::getMapData(map)) {
  if (missing(labelOptions)) {
    labelOptions <- leaflet::labelOptions()
  }
  if (!is.null(icon)) {
    icon <- leaflet::evalFormula(list(icon), data)[[1]]
    if (inherits(icon, "leaflet_icon_set")) {
      icon <- iconSetToIcons(icon)
    }
    icon$iconUrl <- b64EncodePackedIcons(packStrings(icon$iconUrl))
    icon$iconRetinaUrl <- b64EncodePackedIcons(packStrings(icon$iconRetinaUrl))
    icon$shadowUrl <- b64EncodePackedIcons(packStrings(icon$shadowUrl))
    icon$shadowRetinaUrl <- b64EncodePackedIcons(packStrings(icon$shadowRetinaUrl))
    if (length(icon$iconSize) == 2) {
      if (is.numeric(icon$iconSize[[1]]) && is.numeric(icon$iconSize[[2]])) {
        icon$iconSize <- list(icon$iconSize)
      }
    }
    icon <- leaflet::filterNULL(icon)
  }

  map$dependencies <- c(map$dependencies, bounceMarkerDependency())

  # if (!is.null(clusterOptions))
  #   map$dependencies = c(map$dependencies, leaflet::leafletDependencies$markerCluster())

  pts <- leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addBounceMarkers"
  )

  leaflet::invokeMethod(
    map, data, "addBounceMarkers", pts$lat, pts$lng, icon, layerId, duration, height,
    group, options, popup, popupOptions,
    # clusterOptions, clusterId,
    NULL, NULL,
    leaflet::safeLabel(label, data), labelOptions,
    # leaflet:::getCrosstalkOptions(data)
    NULL
  ) %>% leaflet::expandLimits(pts$lat, pts$lng)
}
