library(leaflet.extras)
library(magrittr)

leaf <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron)

#' ## With Polygons
#'
json <- paste(readLines('inst/examples/dc-ward-2012.geojson'),collapse = '')

json.l <- jsonlite::fromJSON(json)

factpal <- colorFactor(topo.colors(nrow(json.l$features$properties)),
                       json.l$features$properties$NAME)

# Generate one HTML Table per feature with all properties of a feature.
popups <-
  purrr::by_row(json.l$features$properties,
                function(row) {
                  htmlTable::htmlTable(
                    t(row),
                    caption='Ward Details',
                    align='left',
                    align.header='left',
                    col.rgroup=c('#ffffff','#eeeeee'))},
                .collate = 'list', .labels = F)

json.l$features$properties$popup = purrr::map_chr(popups$.out,~as.character(.))
json.l$features$properties$style = purrr::map(factpal(json.l$features$properties$NAME),~list(fillColor=., color=.))

leaf %>% setView(-77.0369, 38.9072, 11) %>%
  addGeoJSONv2(jsonlite::toJSON(json.l), weight = 1, fillOpacity = 0.6,
             popupProperty='popup', labelProperty='NAME',
             highlightOptions =
               highlightOptions(weight=2, color='#000000',
                                fillOpacity=1, opacity =1,
                                bringToFront=TRUE, sendToBack=TRUE))


#' ## With Polygons 2
fName <- 'https://raw.githubusercontent.com/MinnPost/simple-map-d3/master/example-data/world-population.geo.json'

readGeoJson_ <- function(fName) {
  jsonlite::fromJSON(paste0(readLines(fName)))
}

readGeoJson <- memoise::memoise(readGeoJson_)
geoJson <- readGeoJson(fName)

geoJson$features$properties$POP_DENSITY <-
  as.numeric(geoJson$features$properties$POP2005) /
    max(as.numeric(geoJson$features$properties$AREA),1)

pal <- colorNumeric(
  colormap::colormap(colormap::colormaps$copper,nshades = 256, reverse = TRUE),
  geoJson$features$properties$POP_DENSITY)

# Generate one HTML Table per feature with all properties of a feature.
popups <-
  purrr::by_row(geoJson$features$properties,
                function(row) {
                  htmlTable::htmlTable(
                    t(row),
                    caption='Country Details',
                    align='left',
                    align.header='left',
                    col.rgroup=c('#ffffff','#eeeeee'))},
                .collate = 'list', .labels = F)

geoJson$features$properties$popup = purrr::map_chr(popups$.out,~as.character(.))
geoJson$features$properties$style = purrr::map(pal(geoJson$features$properties$POP_DENSITY),~list(fillColor=.))

leaflet(options =
          leafletOptions(
            maxZoom = 5,
            crs=leafletCRS(
              crsClass="L.Proj.CRS", code='ESRI:53009',
              proj4def= '+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs',
              resolutions = c(65536, 32768, 16384, 8192, 4096, 2048)
            ))) %>%
  addGraticule(style= list(color= '#999', weight= 0.5, opacity= 1)) %>%
  addGraticule(sphere = TRUE, style= list(color= '#777', weight= 1, opacity= 0.25)) %>%
  addEasyButton(easyButton(
    icon = 'ion-arrow-shrink',
    title = 'Reset View',
    onClick = JS("function(btn, map){ map.setView([0,0],0); }")
  )) %>%
  addGeoJSONv2(
    rmapshaper::ms_simplify(geojsonio::as.json(geoJson)),
    weight = 1, fillOpacity = 0.6, color = '#ffffff',
    popupProperty='popup', labelProperty='NAME',
    highlightOptions = highlightOptions(
      weight=2, color='#000000',
      fillOpacity=1, opacity =1,
      bringToFront=TRUE, sendToBack=TRUE))



#' ## With Markers
jsURL <- 'https://rawgit.com/Norkart/Leaflet-MiniMap/master/example/local_pubs_restaurant_norway.js'
v8 <- V8::v8()
v8$source(jsURL)
geoJson <- v8$get('pubsGeoJSON')

icons <- awesomeIconList(
  pub = makeAwesomeIcon(icon='glass', library='fa', markerColor = 'red'),
  restaurant = makeAwesomeIcon(icon='cutlery', library='fa', markerColor = 'blue')
)

leaf %>%
  setView(15, 65, 5) %>%
  addGeoJSONv2(jsonlite::toJSON(geoJson),
             labelProperty='name',
             markerIcons = icons, markerIconProperty = 'amenity',
             markerOptions = markerOptions(riseOnHover = TRUE, opacity = 0.75),
             clusterOptions = markerClusterOptions())

