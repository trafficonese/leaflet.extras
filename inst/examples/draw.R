library(leaflet.extras)

#' ### Draw features on a blank slate

#+ fig.width=10, fig.height=8
leaflet() %>%
  setView(0,0,2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addDrawToolbar(
    targetGroup='draw',
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c('draw'), options =
                     layersControlOptions(collapsed=FALSE)) %>%
  addStyleEditor()

#' <br/><br/><br/>
#' ### Add features and then make then editable.<br/>
#' The `group` param of `add*` methods has to match the `targetGroup` param of `addDrawToolbar`.

cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

#+ fig.width=10, fig.height=8
leaflet(cities) %>% addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             radius = ~sqrt(Pop) * 30, label = ~City, group ='cities') %>%
  addDrawToolbar(
    targetGroup='cities',
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c('cities'), options =
                     layersControlOptions(collapsed=FALSE)) %>%
  addStyleEditor()

#' <br/><br/><br/>
#' ### Add GeoJSON and then edit it
#' The layerId of the GeoJSON has to match the targetLayerId of `addDrawToolbar`

fName <- 'https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson'

geoJson <- readr::read_file(fName)

leaflet() %>% addTiles() %>% setView(-77.0369, 38.9072, 11) %>%
  addBootstrapDependency() %>%
  addGeoJSONChoropleth(
    geoJson,
    valueProperty = 'AREASQMI',
    scale = c('white','red'), mode='q', steps = 4, padding = c(0.2,0),
    labelProperty='NAME',
    popupProperty=propstoHTMLTable(
      props = c('NAME', 'AREASQMI', 'REP_NAME', 'WEB_URL', 'REP_PHONE', 'REP_EMAIL', 'REP_OFFICE'),
      table.attrs = list(class='table table-striped table-bordered'),drop.na = T),
    color='#ffffff', weight=1, fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight=2, color='#000000',
      fillOpacity=1, opacity =1,
      bringToFront=TRUE, sendToBack=TRUE),
    legendOptions = legendOptions(title='Area in Sq. Miles'),
    group = 'wards', layerId = 'dc-wards') %>%
  addDrawToolbar(
    targetLayerId='dc-wards',
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c('wards'),
                   options = layersControlOptions(collapsed=FALSE)) %>%
  addStyleEditor()

