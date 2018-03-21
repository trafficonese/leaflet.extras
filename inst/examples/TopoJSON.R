#' ---
#' title: "Plotting TopoJSON Data using leaflet.extras"
#' author: "Bhasar V. Karambelkar"
#' ---

library(leaflet.extras)

#' ## Point Data

#' We plot US Airports both as individual points and as heatmap.

fName <- "https://rawgit.com/mbostock/4408297/raw/e7ff08dbcfce3e15663baf9078ab0ff51a72023c/airports.json"

topoJson <- readr::read_file(fName)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(-98.583333, 39.833333, 4) %>%
  addWebGLGeoJSONHeatmap(
    topoJson, size = 20, units = "px") %>%
  addGeoJSONv2(
    topoJson,
    markerType = "circleMarker",
    stroke = FALSE, fillColor = "black", fillOpacity = 1,
    markerOptions = markerOptions(radius = 1))

#' ## Shape Data

#' We plot some crime stats by district. Notice the convenient "propsToHTMLTable" function for pretty popups.
#'
fName <- "https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson"
topoJson <- readr::read_file(fName)

leaflet() %>%
  addBootstrapDependency() %>%
  setView(-75.14, 40, zoom = 11) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addGeoJSONChoropleth(
    topoJson,
    valueProperty = "incidents",
    scale = "OrRd", mode = "q", steps = 5,
    padding = c(0.2, 0),
    popupProperty = propstoHTMLTable(
      props = c("dist_numc", "location", "incidents", "_feature_id_string"),
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    labelProperty = JS("function(feature){return \"WARD: \" + feature.properties.dist_numc;}"),
    color = "#ffffff", weight = 1, fillOpacity = 0.7,
    highlightOptions =
      highlightOptions(fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
                        bringToFront = TRUE, sendToBack = TRUE),
    legendOptions =
      legendOptions(title = "Crimes", position = "bottomright"),
    group = "orange-red"
  ) %>%
  addGeoJSONChoropleth(
    fName,
    valueProperty = "incidents",
    scale = c("yellow", "red", "black"), mode = "q", steps = 5,
    bezierInterpolate = TRUE,
    popupProperty = propstoHTMLTable(
      props = c("dist_numc", "location", "incidents", "_feature_id_string"),
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    labelProperty = JS("function(feature){return \"WARD: \" + feature.properties.dist_numc;}"),
    color = "#ffffff", weight = 1, fillOpacity = 0.7,
    highlightOptions =
      highlightOptions(fillOpacity = 1, weight = 2, opacity = 1, color = "#ff00ff",
                        bringToFront = TRUE, sendToBack = TRUE),
    legendOptions =
      legendOptions(title = "Crimes", position = "bottomright"),
    group = "yellow-black"
  ) %>%
  addLayersControl(baseGroups = c("orange-red", "yellow-black"))
