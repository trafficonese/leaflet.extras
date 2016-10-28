library(leaflet)
#library(leaflet.extras)   # für: addTopoJSONChoropleth; Installation: devtools::install_github('TrantorM/leaflet.extras')

R_topojsonObject_asString <- readr::read_file('https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson')                                                                            # system.time: 0.093

leaflet() %>% 
  setView(-75.14, 40, zoom = 11) %>%
  addTiles(urlTemplate = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',options = tileOptions(minZoom = 2, maxZoom = 18, tms = TRUE)) %>%   # wmflabs.org not responding at the moment
  #  addProviderTiles("CartoDB.Positron") %>% 
  leaflet.extras::addTopoJSONChoropleth(
    R_topojsonObject_asString,
    valueProperty ='incidents',
    scale = c('white','red'), mode='q', steps = 5,
    popupProperty = JS("function(feature){return 'District ' + feature.properties.dist_num + '<br>' + feature.properties.incidents.toLocaleString() + ' incidents';}"),
    labelProperty = 'dist_num',
    color='#ffffff', weight=1, fillOpacity = 0.7
  )
