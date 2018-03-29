library(leaflet.extras)


airports <- readr::read_file(
  system.file("examples/data/gpx/md-airports.gpx.zip", package = "leaflet.extras"))
towns <- readr::read_file(
  system.file("examples/data/gpx/md-towns.gpx.zip", package = "leaflet.extras"))

leaflet() %>%
  addBootstrapDependency() %>%
  setView(-76.6413, 39.0458, 8) %>%
  addProviderTiles(providers$CartoDB.Positron,
                   options = providerTileOptions(detectRetina = T)) %>%
  addWebGLGPXHeatmap(airports, size = 20000, group = "airports", opacity = 0.9) %>%
  addGPX(airports,
         markerType = "circleMarker",
         stroke = FALSE, fillColor = "black", fillOpacity = 1,
         markerOptions = markerOptions(radius = 1.5),
         group = "airports") %>%
  addWebGLGPXHeatmap(towns, size = 15000, group = "towns", opacity = 0.9) %>%
  addGPX(towns,
         markerType = "circleMarker",
         stroke = FALSE, fillColor = "black", fillOpacity = 1,
         markerOptions = markerOptions(radius = 1.5),
         group = "towns") %>%
  addLayersControl( baseGroups = c("airports", "towns"),
                    options = layersControlOptions(collapsed = FALSE))
