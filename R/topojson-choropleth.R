#' Adds a TopoJSON Choropleth.
#' @param topojson either as a list or a string
#' @rdname geojson-choropleth
#' @export
addTopoJSONChoropleth = function(
  map, topojson, layerId = NULL, group = NULL,
  valueProperty,
  labelProperty = NULL, labelOptions = leaflet::labelOptions(),
  popupProperty = NULL, popupOptions = leaflet::popupOptions(),
  scale = c('white','red'),
  steps =5,
  mode = 'q',
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
  highlightOptions = NULL
) {
  map$dependencies <- c(map$dependencies, omnivoreDependencies())
  map$dependencies <- c(map$dependencies,
                        geoJSONChoroplethDependency())
  pathOptions =c(pathOptions, list(
    valueProperty=valueProperty,
    scale=scale,
    steps=steps,
    mode=mode,
    colors=colors,
    stroke=stroke,
    color=color,
    weight=weight,
    opacity=opacity,
    fillOpacity=fillOpacity,
    dashArray=dashArray,
    smoothFactor=smoothFactor,
    noClip=noClip
  ))
  leaflet::invokeMethod(
    map, leaflet::getMapData(map), 'addTopoJSONChoropleth',
    topojson, layerId, group,
    labelProperty, labelOptions, popupProperty, popupOptions,
    pathOptions, highlightOptions
    )
}
