#' ---
#' title: "Plotting CSV Data using leaflet.extras"
#' author: "Bhasar V. Karambelkar"
#' ---

library(leaflet.extras)

#' ## Point Data

#' Nearyly 50K World Airports

fName <- system.file("examples/data/csv/world_airports.csv.zip", package = "leaflet.extras")

csv <- readr::read_file(fName)

leaf <- leaflet() %>%
  setView(0, 0, 2) %>%
  addProviderTiles(providers$CartoDB.DarkMatterNoLabels)

#+ fig.width=10
leaf %>%
  addCSV(
    csv,
    csvParserOptions("latitude_deg", "longitude_deg"),
    markerType = "circleMarker",
    stroke = FALSE, fillColor = "red", fillOpacity = 1,
    markerOptions = markerOptions(radius = 0.5))

#' <br/><br/>Same data as a heatmap.

#+ fig.width=10
leaf %>%
  addWebGLCSVHeatmap(
    csv,
    csvParserOptions("latitude_deg", "longitude_deg"),
    size = 3, units = "px")
