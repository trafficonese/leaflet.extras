fName <- 'https://raw.githubusercontent.com/MinnPost/simple-map-d3/master/example-data/world-population.geo.json'

readGeoJson_ <- function(fName) {
  rmapshaper::ms_simplify(paste0(readLines(fName)))
}

readGeoJson <- memoise::memoise(readGeoJson_)
geoJson <- readGeoJson(fName)

library(leaflet.extras)

#' Just some fancy projection coz Spherical Mercator sucks.
leaf <- leaflet(options =
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
  ))


#' The options `valueProperty`, `scale`, `mode`, `steps` are for the choropleth generation.
#' `valueProperty` can be a simple property or a JS function that computes a value as shown below.<br/>
#' In addition you can specify `labelProperty` & `popupProperty` both of which can be simple property names or functions that generate string/HTML.

#+ fig.width=8, fig.height=5
leaf %>%
  addGeoJSONChoropleth(
    geoJson,
    valueProperty =
      JS("function(feature) {
           return feature.properties.POP2005/Math.max(feature.properties.AREA,1);
         }"),
    scale = c('white','blue','red'), mode='q', steps = 10,
    popupProperty =
      JS("function(feature){
            return '<ul>' +
            '<li>Name: <em>' + feature.properties.NAME + '</em></li>' +
            '<li>Region: <em>' + feature.properties.REGION + '</em></li>' +
            '<li>Population Density: <em>' + (feature.properties.POP2005/feature.properties.AREA).toLocaleString() + '</em></li>' +
            '</ul>';
      }"),
    labelProperty = 'NAME',
    color='#ffffff', weight=1, fillOpacity = 0.7,
    highlightOptions =
      highlightOptions(fillOpacity=1, weight=2, opacity=1, color='#000000',
                        bringToFront=TRUE, sendToBack = TRUE)
 )
