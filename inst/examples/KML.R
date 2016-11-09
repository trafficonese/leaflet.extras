#' ---
#' title: "Plotting KML Data using leaflet.extras"
#' author: "Bhasar V. Karambelkar"
#' ---

library(leaflet.extras)

#' ## Point Data

#' We plot crime incidents in Washington DC and a heatmap of them.

fName <- system.file('examples/kml/crimes.kml', package = 'leaflet.extras')

kml <- readr::read_file(fName)

leaflet() %>% setView(-77.0369, 38.9072, 12) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addWebGLKMLHeatmap(kml, size = 20, units = 'px') %>%
  addKML(
    kml,
    markerType = 'circleMarker',
    stroke=FALSE, fillColor='black', fillOpacity = 1,
    markerOptions = leaflet::markerOptions(radius=1))

#' ## Shape Data

#' We plot US states. Notice the convenient 'propsToHTMLTable' function for pretty popups.

fName <- system.file('examples/kml/cb_2015_us_state_20m.kml', package = 'leaflet.extras')

kml <- readr::read_file(fName)


leaflet() %>%
  addBootstrapDependency() %>%
  setView(-98.583333, 39.833333, 4) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  leaflet.extras::addKMLChoropleth(
    kml,
    valueProperty ='ALAND',
    scale = c('white','red'), mode='q', steps = 10,
    popupProperty = 'description',
    labelProperty = 'NAME',
    color='#ffffff', weight=1, fillOpacity = 0.7,
    highlightOptions =
      highlightOptions(fillOpacity=1, weight=2, opacity=1, color='#000000',
                       bringToFront=TRUE, sendToBack = TRUE)
  )
