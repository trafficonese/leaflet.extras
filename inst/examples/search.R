#' ---
#' title: "Search Markers or GeoJSON features"
#' output:
#'   html_document:
#'     self_contained: true
#' ---

library(leaflet.extras)


#' ### Geocoding using Various Geocoder
# GeoCoding ----
leaflet() %>%
  addProviderTiles(providers$Esri.WorldStreetMap) %>%
  addResetMapButton() %>%
  addSearchOSM() %>%
  addSearchGoogle() %>%
  addSearchUSCensusBureau()

#' Reverse Geocoding using OSM
# Reverse Geocoding ----
leaflet()  %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  addResetMapButton() %>%
  addReverseSearchOSM()

#' ### Search Markers
# Markers ----
cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

leaflet(cities) %>% addProviderTiles(providers$OpenStreetMap) %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1, fillOpacity = 0.5,
             radius = ~sqrt(Pop) * 10, popup = ~City, label = ~City, group = "cities") %>%
  addResetMapButton() %>%
  addSearchFeatures(
    targetGroups = "cities",
    options = searchFeaturesOptions(
      zoom = 12, openPopup = TRUE, firstTipSubmit = TRUE,
      autoCollapse = TRUE, hideMarkerOnCollapse = TRUE )) %>%
  addControl("<P><B>Hint!</B> Search for ...<br/><ul><li>New York</li><li>Boston</li><li>Hartford</li><li>Philadelphia</li><li>Pittsburgh</li><li>Providence</li></ul></P>",
             position = "bottomright")

#' ### Search Polygons
# Polygons ----
nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"))
leaflet(nc) %>%
  addTiles() %>%
  addPolygons(label = ~NAME, popup = ~NAME, group = "nc") %>%
  addResetMapButton() %>%
  addSearchFeatures(
    targetGroups  = "nc",
    options = searchFeaturesOptions(zoom = 10, openPopup = TRUE))

#' ### Search GeoJSON Markers
# GeoJSON w/ Markers ----
jsURL <- "https://rawgit.com/Norkart/Leaflet-MiniMap/master/example/local_pubs_restaurant_norway.js"
v8 <- V8::v8()
v8$source(jsURL)
geoJson <- v8$get("pubsGeoJSON")

# Is it a pub or a restaurant?
icons <- awesomeIconList(
  pub = makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "red"),
  restaurant = makeAwesomeIcon(icon = "cutlery", library = "fa", markerColor = "blue")
)

leaflet() %>% addProviderTiles(providers$Esri.WorldStreetMap) %>%
  addBootstrapDependency() %>%
  setView(15, 65, 5) %>%
  addGeoJSONv2(
    jsonlite::toJSON(geoJson),
    labelProperty = "name",
    popupProperty = propstoHTMLTable(
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    markerIcons = icons, markerIconProperty = "amenity",
    markerOptions = markerOptions(riseOnHover = TRUE, opacity = 0.75),
    clusterOptions = markerClusterOptions(),
    group = "pubs") %>%
  addResetMapButton() %>%
  addSearchFeatures(
    targetGroups = "pubs",
    options = searchFeaturesOptions(
      propertyName = "name", zoom = 18, openPopup = TRUE, firstTipSubmit = TRUE,
      autoCollapse = TRUE, hideMarkerOnCollapse = TRUE )) %>%
  addControl("<P>Search for pub/restaurants<br/>in Norway by name.</P>",
             position = "bottomright")


#' ### Search GeoJSON Polygons
# GeoJSON w/ Polygons ----

fName <- "https://raw.githubusercontent.com/MinnPost/simple-map-d3/master/example-data/world-population.geo.json"
geoJson <- jsonlite::fromJSON(readr::read_file(fName))
# The geojson in question has some invalid geometry which needs to be fixed
# before we can use it in a custom projection.
geoJson <- geojsonio::as.json(geoJson) %>%
  rmapshaper::ms_simplify()

leaf.world <- leaflet(
  options = leafletOptions(
    maxZoom = 5,
    crs = leafletCRS(
      crsClass = "L.Proj.CRS", code = "ESRI:53009",
      proj4def = "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs",
      resolutions = c(65536, 32768, 16384, 8192, 4096, 2048)))) %>%
  addGraticule(style = list(color = "#999", weight = 0.5, opacity = 1, fill = NA)) %>%
  addGraticule(sphere = TRUE, style = list(color = "#777", weight = 1, opacity = 0.25, fill = NA)) %>%
  addEasyButton(easyButton(
    icon = "ion-arrow-shrink",
    title = "Reset View",
    onClick = JS("function(btn, map){ map.setView([0,0],1); }"))) %>%
  setMapWidgetStyle(list(background = "white"))


#' The options `valueProperty`, `scale`, `mode`, `steps` are for the choropleth generation.
#' `valueProperty` can be a simple property or a JS function that computes a value as shown below.<br/>
#' In addition you can specify `labelProperty` & `popupProperty` both of which can be simple property names or functions that generate string/HTML.

leaf.world %>%
  addBootstrapDependency() %>%
  addGeoJSONChoropleth(
    geoJson, group = "pop_density",
    # Calculate the Population Density of each country
    valueProperty =
      JS("function(feature) {
           return feature.properties.POP2005/Math.max(feature.properties.AREA,1);
         }"),
    scale = c("#ffc77fff", "#000000ff"), mode = "q", steps = 5,
    # Select the data attributes to show in the popup.
    popupProperty = propstoHTMLTable(
      props = c("NAME", "REGION", "ISO_3_CODE", "ISO_2_CODE", "AREA", "POP2005"),
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    labelProperty = "NAME",
    color = "#ffffff", weight = 1, fillOpacity = 0.9,
    highlightOptions = highlightOptions(
      fillOpacity = 1, weight = 2, opacity = 1, color = "#ff0000",
      bringToFront = TRUE, sendToBack = TRUE),
    legendOptions = legendOptions(title = "Population Density (2005)")) %>%
  addSearchFeatures(
    targetGroups = "pop_density",
    options = searchFeaturesOptions(
      propertyName = "NAME", zoom = 2, openPopup = TRUE, firstTipSubmit = TRUE,
      autoCollapse = FALSE, hideMarkerOnCollapse = TRUE )) %>%
  addControl("<P><B>Hint!</B> Search for a Country by name</P>",
             position = "bottomright")

#' ### Search Multiple GeoJSON Layers
# GeoJSON Groups w/ Markers ----
artsAndCultures <- readr::read_file(
  "https://rawgit.com/benbalter/dc-maps/master/maps/arts-and-culture-organizations-as-501-c-3.geojson")
bankLocations <- readr::read_file(
  "https://raw.githubusercontent.com/benbalter/dc-maps/master/maps/bank-locations.geojson")

artsAndCulture <- makeAwesomeIcon(icon = "paintbrush", library = "ion", markerColor = "red", iconColor = "black")
bankLocation <- makeAwesomeIcon(icon = "cash", library = "ion", markerColor = "green", iconColor = "black")

leaf <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addResetMapButton()

leaf %>% setView(-77.0369, 38.9072, 12) %>%
  addBootstrapDependency() %>%
  addGeoJSONv2(
    artsAndCultures,
    labelProperty = "NAME",
    popupProperty = propstoHTMLTable(
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    labelOptions = labelOptions(textsize = "12px", direction = "auto" ),
    markerIcons = artsAndCulture,
    markerOptions = markerOptions(riseOnHover = TRUE, opacity = 1),
    clusterOptions = markerClusterOptions(), group = "Arts-n-Culture") %>%
  addGeoJSONv2(
    bankLocations,
    labelProperty = "NAME",
    popupProperty = propstoHTMLTable(
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    labelOptions = labelOptions(textsize = "12px", direction = "auto" ),
    markerIcons = bankLocation,
    markerOptions = markerOptions(riseOnHover = TRUE, opacity = 1),
    clusterOptions = markerClusterOptions(), group = "Bank Locations") %>%
  addLayersControl(
    overlayGroups =  c("Arts-n-Culture", "Bank Locations"),
    options = layersControlOptions(collapsed = F)) %>%
  addSearchFeatures(
    targetGroups =  c("Arts-n-Culture", "Bank Locations"),
    options = searchFeaturesOptions(
      propertyName = "NAME", zoom = 18, openPopup = TRUE, firstTipSubmit = TRUE,
      autoCollapse = TRUE, hideMarkerOnCollapse = TRUE, position = "topleft" )) %>%
  addControl("<P><B>Hint!</B> Search for Arts-N-Culture or Bank Locations</P>",
             position = "bottomright")
