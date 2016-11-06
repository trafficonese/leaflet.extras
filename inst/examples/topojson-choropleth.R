library(leaflet.extras)

fName <- 'https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson'

R_topojsonObject_asString <-
    readr::read_file('https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson')

leaflet() %>%
  addBootstrapDependency() %>%
  setView(-75.14, 40, zoom = 11) %>%
  #addTiles(urlTemplate = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',options = tileOptions(minZoom = 2, maxZoom = 18, tms = TRUE)) %>%   # wmflabs.org not responding at the moment
  addProviderTiles(providers$CartoDB.Positron) %>%
  leaflet.extras::addTopoJSONChoropleth(
    #R_topojsonObject_asString,
    fName,
    valueProperty ='incidents',
    scale = c('white','red'), mode='q', steps = 5,
    popupProperty = propstoHTMLTable(
      table.attrs = list(class='table table-striped table-bordered'),drop.na = T),
    labelProperty = 'dist_num',
    color='#ffffff', weight=1, fillOpacity = 0.7,
    highlightOptions =
      highlightOptions(fillOpacity=1, weight=2, opacity=1, color='#000000',
                        bringToFront=TRUE, sendToBack = TRUE)
  )
