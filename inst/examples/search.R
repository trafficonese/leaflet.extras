#' ---
#' title: "Search Markers or GeoJSON features"
#' output:
#'   html_document:
#'     self_contained: true
#' ---

library(leaflet.extras)

#' ### Search Markers
cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

leaflet(cities) %>% addTiles() %>%
  addCircleMarkers(lng = ~Long, lat = ~Lat, weight = 1, fillOpacity=0.5,
             radius = ~sqrt(Pop)/50 , popup = ~City, label=~City, group ='cities') %>%
  addSearchMarker(
    targetGroup = 'cities',
    options = searchMarkersOptions(zoom=12, openPopup = TRUE)) %>%
  addControl("<P>Search for ...<br/><ul><li>New York</li><li>Boston</li><li>Hartford</li><li>Philadelphia</li><li>Pittsburgh</li><li>Providence</li></ul></P>",
             position='bottomright')

#' ### Search GeoJSON Features
jsURL <- 'https://rawgit.com/Norkart/Leaflet-MiniMap/master/example/local_pubs_restaurant_norway.js'
v8 <- V8::v8()
v8$source(jsURL)
geoJson <- v8$get('pubsGeoJSON')

# Is it a pub or a restaurant?
icons <- awesomeIconList(
  pub = makeAwesomeIcon(icon='glass', library='fa', markerColor = 'red'),
  restaurant = makeAwesomeIcon(icon='cutlery', library='fa', markerColor = 'blue')
)

leaflet() %>% addTiles() %>%
  addBootstrapDependency() %>%
  setView(15, 65, 5) %>%
  addGeoJSONv2(
    jsonlite::toJSON(geoJson),
    labelProperty='name',
    popupProperty = propstoHTMLTable(
      table.attrs = list(class='table table-striped table-bordered'),drop.na = T),
    markerIcons = icons, markerIconProperty = 'amenity',
    markerOptions = markerOptions(riseOnHover = TRUE, opacity = 0.75),
    clusterOptions = markerClusterOptions(),
    layerId = 'pubs') %>%
  addSearchMarker(
    targetLayerId = 'pubs',
    options = searchMarkersOptions(propertyName = 'name', zoom=18, openPopup = TRUE)) %>%
  addControl("<P>Search for pub/restaurants<br/>in Norway by name.</P>",
             position='bottomright')


