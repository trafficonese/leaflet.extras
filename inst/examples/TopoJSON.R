#' ---
#' title: "Plotting TopoJSON Data using leaflet.extras"
#' author: "Bhasar V. Karambelkar"
#' ---

library(leaflet.extras)

#' ## Point Data

#' We plot US Airports both as individual points and as heatmap.

fName <- 'https://rawgit.com/mbostock/4408297/raw/e7ff08dbcfce3e15663baf9078ab0ff51a72023c/airports.json'

topoJson <- readr::read_file(fName)

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

#' ## Shape Data

#' We plot some crime stats by district. Notice the convenient 'propsToHTMLTable' function for pretty popups.
#' Also notice that we didn't even read the TopoJSON URL in R, it's read directly in browser.
#'
fName <- 'https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson'


leaflet() %>%
  addBootstrapDependency() %>%
  setView(-75.14, 40, zoom = 11) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  leaflet.extras::addTopoJSONChoropleth(
    fName,
    valueProperty ='incidents',
    scale = c('white','red'), mode='q', steps = 5,
    popupProperty = propstoHTMLTable(
      props = c('dist_numc', 'location', 'incidents', '_feature_id_string'),
      table.attrs = list(class='table table-striped table-bordered'),drop.na = T),
    labelProperty = 'dist_num',
    color='#ffffff', weight=1, fillOpacity = 0.7,
    highlightOptions =
      highlightOptions(fillOpacity=1, weight=2, opacity=1, color='#000000',
                        bringToFront=TRUE, sendToBack = TRUE)
  )

