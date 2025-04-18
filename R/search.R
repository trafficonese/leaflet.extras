leafletSearchDependencies <- function() {
  list(
    html_dep_prod("fuse_js", "7.0.0"),
    html_dep_prod("lfx-search", "4.0.0", has_style = TRUE, has_binding = TRUE)
  )
}


#' Options for search control.
#' @param url url for search by ajax request, ex: `search.php?q=\{s\}`. Can be function that returns string for dynamic parameter setting.
#' @param sourceData function that fill _recordsCache, passed searching text by first param and callback in second.
#' @param jsonpParam jsonp param name for search by jsonp service, ex: "callback".
#' @param propertyLoc field for remapping location, using array: ["latname","lonname"] for select double fields(ex. ["lat","lon"] ) support dotted format: "prop.subprop.title".
#' @param propertyName property in marker.options(or feature.properties for vector layer) trough filter elements in layer,.
#' @param formatData callback for reformat all data from source to indexed data object.
#' @param filterData callback for filtering data from text searched, params: textSearch, allRecords.
#' @param filtersearch Optional comma-separated string to prepend to the search text
#' @param moveToLocation whether to move to the found location
#' @param zoom zoom to this level when moving to location
#' @param buildTip function that return row tip html node(or html string), receive text tooltip in first param.
#' @param container container id to insert Search Control
#' @param minLength minimal text length for autocomplete
#' @param initial search elements only by initial text
#' @param casesensitive search elements in case sensitive text
#' @param autoType complete input with first suggested result and select this filled-in text
#' @param delayType delay while typing for show tooltip.
#' @param tooltipLimit limit max results to show in tooltip. -1 for no limit
#' @param tipAutoSubmit auto map panTo when click on tooltip
#' @param firstTipSubmit auto select first result con enter click
#' @param autoResize autoresize on input change
#' @param collapsed collapse search control at startup
#' @param autoCollapse collapse search control after submit(on button or on tips if enabled tipAutoSubmit).
#' @param autoCollapseTime delay for autoclosing alert and collapse after blur.
#' @param textErr Error message
#' @param textCancel title in cancel button
#' @param textPlaceholder placeholder value
#' @param position position of the search input. Default is "topleft".
#' @param hideMarkerOnCollapse remove circle and marker on search control collapsed.
#' @param marker Let's you set the icon. Can be an icon made by \code{\link[leaflet]{makeIcon}} or \code{\link[leaflet]{makeAwesomeIcon}}
#' @rdname search-options
#' @export
searchOptions <- function(
    url = NULL,
    sourceData = NULL,
    jsonpParam = NULL,
    propertyLoc = NULL,
    propertyName = NULL,
    formatData = NULL,
    filterData = NULL,
    filtersearch = NULL,
    moveToLocation = TRUE,
    zoom = 17,
    buildTip = NULL,
    container = "",
    minLength = 1,
    initial = TRUE,
    casesensitive = FALSE,
    autoType = TRUE,
    delayType = 400,
    tooltipLimit = -1,
    tipAutoSubmit = TRUE,
    firstTipSubmit = FALSE,
    autoResize = TRUE,
    collapsed = TRUE,
    autoCollapse = FALSE,
    autoCollapseTime = 1200,
    textErr = "Location Not Found",
    textCancel = "Cancel",
    textPlaceholder = "Search...",
    position = "topleft",
    hideMarkerOnCollapse = FALSE,
    marker = list(
      icon = NULL,
      animate = TRUE,
      circle = list(
        radius = 10,
        weight = 3,
        color = "#e03",
        stroke = TRUE,
        fill = FALSE
      )
    )) {
  leaflet::filterNULL(list(
    url = url,
    sourceData = sourceData,
    jsonpParam = jsonpParam,
    propertyLoc = propertyLoc,
    propertyName = propertyName,
    formatData = formatData,
    filterData = filterData,
    filtersearch = filtersearch,
    moveToLocation = moveToLocation,
    zoom = zoom,
    buildTip = buildTip,
    container = container,
    minLength = minLength,
    initial = initial,
    casesensitive = casesensitive,
    autoType = autoType,
    delayType = delayType,
    tooltipLimit = tooltipLimit,
    tipAutoSubmit = tipAutoSubmit,
    firstTipSubmit = firstTipSubmit,
    autoResize = autoResize,
    collapsed = collapsed,
    autoCollapse = autoCollapse,
    autoCollapseTime = autoCollapseTime,
    textErr = textErr,
    textCancel = textCancel,
    textPlaceholder = textPlaceholder,
    position = position,
    hideMarkerOnCollapse = hideMarkerOnCollapse,
    marker = marker
  ))
}

#' Add a OSM search control to the map.
#'
#' @param map a map widget object
#' @param options Search Options
#' @return modified map
#' @rdname search-geocoding
#' @export
addSearchOSM <- function(map,
                         options = searchOptions(autoCollapse = TRUE, minLength = 2)) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())

  result <- makeSearchIcon(map, options)
  map <- result$map
  options$marker$icon <- result$icon

  invokeMethod(
    map,
    getMapData(map),
    "addSearchOSM",
    options
  )
}

#' Add a OSM search control to the map.
#'
#' @param map a map widget object
#' @param text The search text
#' @return modified map
#' @rdname search-geocoding
#' @export
searchOSMText <- function(map, text = "") {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    NULL,
    "searchOSMText",
    text
  )
}

#' Removes the OSM search control from the map.
#'
#' @return modified map
#' @rdname search-geocoding
#' @export
removeSearchOSM <- function(map) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "removeSearchOSM"
  )
}

#' Clears the search marker
#'
#' @return modified map
#' @rdname search-geocoding
#' @export
clearSearchOSM <- function(map) {
  invokeMethod(
    map,
    getMapData(map),
    "clearSearchOSM"
  )
}

#' @param showSearchLocation Boolean. If TRUE displays a Marker on the searched location's coordinates.
#' @param showBounds Boolean. If TRUE show the bounding box of the found feature.
#' @param showFeature Boolean. If TRUE show the found feature.
#'   Depending upon the feature found this can be a marker, a line or a polygon.
#' @param fitBounds Boolean. If TRUE set maps bounds to queried and found location.
#'   For this to be effective one of \code{showSearchLocation}, \code{showBounds}, \code{showFeature} shoule also be TRUE.
#' @param displayText Boolean. If TRUE show a text box with found location's name on the map.
#' @param group String. An optional group to hold all the searched locations and their results.
#' @param marker Let's you set the icon. Can be an icon made by \code{\link[leaflet]{makeIcon}} or \code{\link[leaflet]{makeAwesomeIcon}}
#' @param showFeatureOptions A list of styling options for the found feature
#' @param showBoundsOptions A list of styling options for the bounds of the found feature
#' @param showHighlightOptions A list of styling options for the hover effect of a found feature
#' @return modified map
#' @rdname search-geocoding
#' @export
addReverseSearchOSM <- function(
    map,
    showSearchLocation = TRUE,
    showBounds = FALSE,
    showFeature = TRUE,
    fitBounds = TRUE,
    displayText = TRUE,
    group = NULL,
    marker = list(
      icon = NULL
    ),
    showFeatureOptions = list(
      weight = 2,
      color = "red",
      dashArray = "5,10",
      fillOpacity = 0.2,
      opacity = 0.5
    ),
    showBoundsOptions = list(
      weight = 2,
      color = "#444444",
      dashArray = "5,10",
      fillOpacity = 0.2,
      opacity = 0.5
    ),
    showHighlightOptions = list(
      opacity = 0.8,
      fillOpacity = 0.5,
      weight = 5
    )) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  if (displayText == TRUE) {
    map <- map %>%
      addControl("Click anywhere on the map to reverse geocode",
        position = "topright", layerId = "reverseSearchOSM"
      )
  }

  result <- makeSearchIcon(map, list("marker" = marker))
  map <- result$map
  marker$icon <- result$icon

  invokeMethod(
    map,
    getMapData(map),
    "addReverseSearchOSM",
    list(
      showSearchLocation = showSearchLocation,
      fitBounds = fitBounds,
      showBounds = showBounds,
      showFeature = showFeature,
      marker = marker,
      showFeatureOptions = showFeatureOptions,
      showBoundsOptions = showBoundsOptions,
      showHighlightOptions = showHighlightOptions
    ),
    group
  )
}

#' Add a Google search control to the map.
#'
#' @param apikey String. API Key for Google GeoCoding Service.
#' @return modified map
#' @rdname search-geocoding
#' @examples
#' leaflet() %>%
#'   addProviderTiles(providers$Esri.WorldStreetMap) %>%
#'   addResetMapButton() %>%
#'   addSearchGoogle()
#'
#' ## for more examples see
#' # browseURL(system.file("examples/search.R", package = "leaflet.extras"))
#'
#' @export
addSearchGoogle <- function(
    map,
    apikey = Sys.getenv("GOOGLE_MAP_GEOCODING_KEY"),
    options = searchOptions(autoCollapse = TRUE, minLength = 2)) {
  url <- "https://maps.googleapis.com/maps/api/js?v=3"
  if (is.null(apikey) || apikey == "") {
    warning("Google Geocoding works best with an apikey")
  } else {
    url <- paste0(url, "&key=", apikey)
  }
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "addSearchGoogle",
    options
  ) %>%
    htmlwidgets::appendContent(htmltools::tags$script(src = url))
}

#' Removes the Google search control from the map.
#'
#' @return modified map
#' @rdname search-geocoding
#' @export
removeSearchGoogle <- function(map) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "removeSearchGoogle"
  )
}

#' @return modified map
#' @rdname search-geocoding
#' @export
addReverseSearchGoogle <- function(
    map,
    apikey = Sys.getenv("GOOGLE_MAP_GEOCODING_KEY"),
    showSearchLocation = TRUE,
    showBounds = FALSE,
    showFeature = TRUE,
    fitBounds = TRUE,
    displayText = TRUE,
    group = NULL) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  url <- "https://maps.googleapis.com/maps/api/js?v=3"
  if (is.null(apikey) || apikey == "") {
    warning("Google Geocoding works best with an apikey")
  } else {
    url <- paste0(url, "&key=", apikey)
  }
  if (displayText == TRUE) {
    map <- map %>%
      addControl("Click anywhere on the map to reverse geocode",
        position = "topright", layerId = "reverseSearchGoogle"
      )
  }
  invokeMethod(
    map,
    getMapData(map),
    "addReverseSearchGoogle",
    list(
      showSearchLocation = showSearchLocation,
      fitBounds = fitBounds,
      showBounds = showBounds,
      showFeature = showFeature
    ),
    group
  ) %>%
    htmlwidgets::appendContent(htmltools::tags$script(src = url))
}

#' Add a US Census Bureau search control to the map.
#'
#' @return modified map
#' @rdname search-geocoding
#' @export
addSearchUSCensusBureau <- function(
    map,
    options = searchOptions(autoCollapse = TRUE, minLength = 20)) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "addSearchUSCensusBureau",
    options
  )
}

#' Removes the US Census Bureau search control from the map.
#'
#' @return modified map
#' @rdname search-geocoding
#' @export
removeSearchUSCensusBureau <- function(map) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "removeSearchUSCensusBureau"
  )
}

#' Customized searchOptions for Feature Search
#' @param openPopup whether to open the popup associated with the feature when the feature is searched for
#' @param ... Other options to pass to \code{\link{searchOptions}()} function.
#' @rdname search-options
#' @export
searchFeaturesOptions <- function(
    propertyName = "label",
    initial = FALSE,
    openPopup = FALSE,
    ...) {
  c(
    openPopup = openPopup,
    searchOptions(
      propertyName = propertyName,
      initial = initial,
      ...
    )
  )
}


#' Add a feature search control to the map.
#'
#' @param map a map widget object
#' @param targetGroups A vector of group names of groups whose features need to be searched.
#' @param options Search Options
#' @return modified map
#' @rdname search-features
#' @export
addSearchFeatures <- function(
    map,
    targetGroups,
    options = searchFeaturesOptions()) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())

  result <- makeSearchIcon(map, options)
  map <- result$map
  options$marker$icon <- result$icon

  invokeMethod(
    map,
    getMapData(map),
    "addSearchFeatures",
    targetGroups,
    options
  )
}

#' Removes the feature search control from the map.
#'
#' @param clearFeatures Boolean. If TRUE the features that this control searches will be removed too.
#' @return modified map
#' @rdname search-features
#' @export
removeSearchFeatures <- function(map, clearFeatures = FALSE) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    "removeSearchFeatures",
    clearFeatures
  )
}

#' Clears the search marker
#'
#' @return modified map
#' @rdname search-features
#' @export
clearSearchFeatures <- function(map) {
  invokeMethod(
    map, NULL, "clearSearchFeatures"
  )
}


makeSearchIcon <- function(map, options) {
  icon <- options$marker$icon
  icon <- if (is.null(icon) || all(is.na(icon)) || isFALSE(icon)) NULL else icon

  if (!is.null(icon)) {
    if (isTRUE(icon)) {
    } else {
      if (inherits(icon, "leaflet_awesome_icon")) {
        map <- addAwesomeMarkersDependencies(map, icon$library)
        icon$awesomemarker <- TRUE
      } else {
        icon$iconUrl <- b64EncodePackedIcons(packStrings(icon$iconUrl))
        icon$iconRetinaUrl <- b64EncodePackedIcons(packStrings(icon$iconRetinaUrl))
        icon$shadowUrl <- b64EncodePackedIcons(packStrings(icon$shadowUrl))
        icon$shadowRetinaUrl <- b64EncodePackedIcons(packStrings(icon$shadowRetinaUrl))
        if (length(icon$iconSize) == 2 && is.numeric(icon$iconSize[[1]]) && is.numeric(icon$iconSize[[2]])) {
          icon$iconSize <- list(icon$iconSize)
        }
      }
      icon <- leaflet::filterNULL(icon)
    }
  }

  return(list(map = map, icon = icon))
}
