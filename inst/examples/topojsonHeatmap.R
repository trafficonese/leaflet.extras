fName <- 'https://rawgit.com/mbostock/4408297/raw/e7ff08dbcfce3e15663baf9078ab0ff51a72023c/airports.json'

topoJson <- readr::read_file(fName)

library(leaflet.extras)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(-98.583333, 39.833333, 4) %>%
  addWebGLGeoJSONHeatmap(
    topoJson, size = 20 , units = 'px') %>%
  addTopoJSONv2(
    topoJson,
    markerType = 'circleMarker',
    stroke=FALSE, fillColor='black', fillOpacity = 1,
    markerOptions = leaflet::markerOptions(radius=1))
