leafletSearchDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "leaflet-search",
      "2.7.0",
      system.file("htmlwidgets/lib/search", package = "leaflet.extras"),
      script = c("leaflet-search.min.js", "leaflet-search-binding.js"),
      stylesheet = "leaflet-search.min.css"
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
    url = '//nominatim.openstreetmap.org/search?format=json&q={s}',
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

#' Customized searchOptions for Marker Search
#' @param openPopup whether to open the popup associated with the marker when the marker is searched for
#' @rdname search-options
#' @export
searchMarkersOptions <- function(
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
#'

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



#' Add a marker search control to the map.
#'
#' @param targetLayerId An optional layerId of a GeoJSON/TopoJSON layer whose features need to be searched.
#' @param targetGroup An optional group name of a Feature Group whose features need to be searched.
#' @return modified map
#' @rdname search
#' @export
addSearchMarker <- function(
    map,
    targetLayerId = NULL,
    targetGroup = NULL,
    options = searchMarkersOptions()
) {
  if(!is.null(targetGroup) && !is.null(targetLayerId) ||
     (is.null(targetGroup) && is.null(targetLayerId))) {
      stop("To search existing features either specify a targetGroup or a targetLayerId, but not both")
  }
    map$dependencies <- c(map$dependencies, leafletSearchDependencies())
    invokeMethod(
        map,
        getMapData(map),
        'addSearchMarker',
        targetLayerId,
        targetGroup,
        options
    )
}
