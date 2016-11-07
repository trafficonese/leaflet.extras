fName <- 'https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson'

geoJson <- readr::read_lines(fName)

library(leaflet.extras)

leaflet() %>% setView(-77.0369, 38.9072, 12) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addWebGLGeoJSONHeatmap(
    geoJson, size = 50 , units = 'px') %>%
  addGeoJSONv2(
    geoJson,
    markerType = 'circleMarker',
    stroke=FALSE, fillColor='black', fillOpacity = 0.7,
    markerOptions = leaflet::markerOptions(radius=2))
