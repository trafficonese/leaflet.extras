leafletSearchDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "leaflet-search",
      "2.7.0",
      system.file("htmlwidgets/lib/search", package = "leaflet.extras"),
      script = c("leaflet-search.src.js", "leaflet-search-binding.js"),
      stylesheet = "leaflet-search.min.css"
    ),
    htmltools::htmlDependency(
      "fuse",
      "3.0.5",
      system.file("htmlwidgets/lib/fuse", package="leaflet.extras"),
      script = c("fuse.js")
    ))
}

#' Options for search control.
#' @param url url for search by ajax request, ex: "search.php?q={s}". Can be function that returns string for dynamic parameter setting.
#' @param sourceData function that fill _recordsCache, passed searching text by first param and callback in second.
#' @param jsonpParam jsonp param name for search by jsonp service, ex: "callback".
#' @param propertyLoc field for remapping location, using array: ['latname','lonname'] for select double fields(ex. ['lat','lon'] ) support dotted format: 'prop.subprop.title'.
#' @param propertyName property in marker.options(or feature.properties for vector layer) trough filter elements in layer,.
#' @param formatData callback for reformat all data from source to indexed data object.
#' @param filterData callback for filtering data from text searched, params: textSearch, allRecords.
#' @param moveToLocation whether to move to the found location.
#' @param zoom zoom to this level when moving to location
#' @param buildTip function that return row tip html node(or html string), receive text tooltip in first param.
#' @param container container id to insert Search Control.
#' @param minLength minimal text length for autocomplete.
#' @param initial search elements only by initial text.
#' @param casesensitive search elements in case sensitive text.
#' @param autoType complete input with first suggested result and select this filled-in text..
#' @param delayType delay while typing for show tooltip.
#' @param tooltipLimit limit max results to show in tooltip. -1 for no limit..
#' @param tipAutoSubmit auto map panTo when click on tooltip.
#' @param firstTipSubmit auto select first result con enter click.
#' @param autoResize autoresize on input change.
#' @param collapsed collapse search control at startup.
#' @param autoCollapse collapse search control after submit(on button or on tips if enabled tipAutoSubmit).
#' @param autoCollapseTime delay for autoclosing alert and collapse after blur.
#' @param textErr 'Location not error message.
#' @param textCancel title in cancel button.
#' @param textPlaceholder placeholder value.
#' @param position 'topleft'.
#' @param hideMarkerOnCollapse remove circle and marker on search control collapsed.
#' @rdname search-options
#' @export
searchOptions <- function(
    url='',
    sourceData=NULL,
    jsonpParam=NULL,
    propertyLoc='loc',
    propertyName='title',
    formatData=NULL,
    filterData=NULL,
    moveToLocation=TRUE,
    zoom=17,
    buildTip=NULL,
    container='',
    minLength=1,
    initial=TRUE,
    casesensitive=FALSE,
    autoType=TRUE,
    delayType=400,
    tooltipLimit=-1,
    tipAutoSubmit=TRUE,
    firstTipSubmit=FALSE,
    autoResize=TRUE,
    collapsed=TRUE,
    autoCollapse=FALSE,
    autoCollapseTime=1200,
    textErr='Location Not Found',
    textCancel='Cancel',
    textPlaceholder='Search...',
    position='topright',
    hideMarkerOnCollapse=FALSE
) {
    leaflet::filterNULL(list(
        url=url,
        sourceData=sourceData,
        jsonpParam=jsonpParam,
        propertyLoc=propertyLoc,
        propertyName=propertyName,
        formatData=formatData,
        filterData=filterData,
        moveToLocation=moveToLocation,
        zoom=zoom,
        buildTip=buildTip,
        container=container,
        minLength=minLength,
        initial=initial,
        casesensitive=casesensitive,
        autoType=autoType,
        delayType=delayType,
        tooltipLimit=tooltipLimit,
        tipAutoSubmit=tipAutoSubmit,
        firstTipSubmit=firstTipSubmit,
        autoResize=autoResize,
        collapsed=collapsed,
        autoCollapse=autoCollapse,
        autoCollapseTime=autoCollapseTime,
        textErr=textErr,
        textCancel=textCancel,
        textPlaceholder=textPlaceholder,
	position=position,
        hideMarkerOnCollapse=hideMarkerOnCollapse
    ))
}

#' Customized searchOptions for opensteetmap search
#' @param ... other options for \code{searchOptions}().
#' @rdname search-options
#' @export
searchOSMOptions <- function(
    url = 'https://nominatim.openstreetmap.org/search?format=json&q={s}',
    jsonpParam = 'json_callback',
    propertyName = 'display_name',
    propertyLoc = c('lat','lon'),
    autoType = FALSE,
    autoCollapse = TRUE,
    minLength = 2,
    ...
) {
  searchOptions(
    url = url,
    jsonpParam = jsonpParam,
    propertyName = propertyName,
    propertyLoc = propertyLoc,
    autoType = autoType,
    autoCollapse = autoCollapse,
    minLength = minLength,
    ...)
}

#' Add a OSM search control to the map.
#'
#' @param map a map widget object
#' @param options Search Options
#' @return modified map
#' @rdname search
#' @export
addSearchOSM <- function(
  map,
  options = searchOSMOptions()
) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    'addSearchOSM',
    options
  )
}

#' Removes the OSM search control from the map.
#'
#' @param map a map widget object
#' @return modified map
#' @rdname search
#' @export
removeSearchOSM <- function(map) {
  #map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    'removeSearchOSM'
  )
}

#' Customized searchOptions for google search
#' @param markerLocation Boolean.
#' @param ... other options for \code{searchOptions}().
#' @rdname search-options
#' @export
searchGoogleOptions <- function(
  markerLocation = TRUE,
  autoType = FALSE,
  autoCollapse = TRUE,
  minLength = 2,
  ...
) {
  c(markerLocation = markerLocation,
    searchOptions(
      autoType = autoType,
      autoCollapse = autoCollapse,
      minLength = minLength,
      ...))
}


#' Add a Google search control to the map.
#'
#' @param map a map widget object
#' @param apikey String. API Key for Google GeoCoding Service.
#' @param options Search Options
#' @return modified map
#' @rdname search
#' @export
addSearchGoogle <- function(
  map,
  apikey = Sys.getenv("GOOGLE_MAP_GEOCODING_KEY"),
  options = searchGoogleOptions()
) {
  if(is.null(apikey)) {
    stop("Google Geocoding requires an apikey")
  }
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    'addSearchGoogle',
    options
  ) %>%
    htmlwidgets::appendContent(
      htmltools::tags$script(
        src=paste0("https://maps.googleapis.com/maps/api/js?v=3&key=", apikey)))
}

#' Removes the Google search control from the map.
#'
#' @param map a map widget object
#' @return modified map
#' @rdname search
#' @export
removeSearchGoogle <- function(map) {
  #map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    'removeSearchGoogle'
  )
}

#' Customized searchOptions for Feature Search
#' @param openPopup whether to open the popup associated with the feature when the feature is searched for
#' @rdname search-options
#' @export
searchFeaturesOptions <- function(
    propertyName = 'label',
    initial = FALSE,
    openPopup = FALSE,
    ...
) {
  c(openPopup = openPopup,
    searchOptions(
       propertyName = propertyName,
       initial = initial,
       ...))
}


#' Add a feature search control to the map.
#'
#' @param targetGroup A vector of group names of groups whose features need to be searched.
#' @return modified map
#' @rdname search
#' @export
addSearchControl <- function(
    map,
    targetGroups,
    options = searchFeaturesOptions()
) {
    map$dependencies <- c(map$dependencies, leafletSearchDependencies())
    invokeMethod(
        map,
        getMapData(map),
        'addSearchControl',
        targetGroups,
        options
    )
}

#' Removes the feature search control from the map.
#'
#' @param map a map widget object
#' @param clearFeatures Boolean. If TRUE the features that this control searches will be removed too.
#' @return modified map
#' @rdname search
#' @export
removeSearchControl <- function(map, clearFeatures=FALSE) {
  map$dependencies <- c(map$dependencies, leafletSearchDependencies())
  invokeMethod(
    map,
    getMapData(map),
    'removeSearchControl',
    clearFeatures
  )
}

