#' ---
#' title: "Plotting KML Data using leaflet.extras"
#' author: "Bhasar V. Karambelkar"
#' ---

library(leaflet.extras)

#' ## Point Data

#' We plot crime incidents in Washington DC and a heatmap of them.

fName <- system.file("examples/data/kml/crimes.kml.zip", package = "leaflet.extras")

kml <- readr::read_file(fName)

leaflet() %>% setView(-77.0369, 38.9072, 12) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addWebGLKMLHeatmap(kml, size = 20, units = "px") %>%
  addKML(
    kml,
    markerType = "circleMarker",
    stroke = FALSE, fillColor = "black", fillOpacity = 1,
    markerOptions = markerOptions(radius = 1))

#' ## Shape Data

#' We plot US states. Notice the convenient "propsToHTMLTable" function for pretty popups.

fName <- system.file("examples/data/kml/cb_2015_us_state_20m.kml.zip",
                     package = "leaflet.extras")

kml <- readr::read_file(fName)


leaflet() %>%
  addBootstrapDependency() %>%
  setView(-98.583333, 39.833333, 4) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addKMLChoropleth(
    kml,
    valueProperty = JS(
      "function(feature){
         var props = feature.properties;
         var aland = props.ALAND/100000;
         var awater = props.AWATER/100000;
         return 100*awater/(awater+aland);
      }"),
    scale = "OrRd", mode = "q", steps = 5,
    padding = c(0.2, 0),
    popupProperty = "description",
    labelProperty = "NAME",
    color = "#ffffff", weight = 1, fillOpacity = 1,
    highlightOptions =
      highlightOptions(fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
                       bringToFront = TRUE, sendToBack = TRUE),
    legendOptions = legendOptions(
      title = "% of Water Area",
      numberFormatOptions = list(style = "decimal",
                                 maximumFractionDigits = 2))
  )
