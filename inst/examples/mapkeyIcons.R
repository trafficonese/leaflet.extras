library(shiny)
library(leaflet)
library(leaflet.extras)

ui <- fluidPage(
  leafletOutput("map")
)

iconSet = mapkeyIconList(
  red = makeMapkeyIcon(icon = "boundary_stone",
                       color = "#725139",
                       background = '#f2c357',
                       iconSize = 30,
                       boxShadow = FALSE),
  blue = makeMapkeyIcon(icon = "traffic_signal",
                        color = "#0000ff",
                        iconSize = 12,
                        boxShadow = FALSE,
                        background = "transparent"),
  buddha = makeMapkeyIcon(icon = "buddhism",
                          color = "red",
                          iconSize = 12,
                          boxShadow = FALSE,
                          background = "transparent")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addMapkeyMarkers(data = breweries91, icon = iconSet,
                       group = "mapkey",
                       label = ~state, popup = ~village)
  })
}
shinyApp(ui, server)



cities <- read.csv(textConnection("City,Lat,Long,Pop
                                  Boston,42.3601,-71.0589,645966
                                  Hartford,41.7627,-72.6743,125017
                                  New York City,40.7127,-74.0059,8406000
                                  Philadelphia,39.9500,-75.1667,1553000
                                  Pittsburgh,40.4397,-79.9764,305841
                                  Providence,41.8236,-71.4222,177994"))

library(dplyr)
cities <- cities %>% mutate(PopCat = ifelse(Pop < 500000, "blue", "red"))


leaflet(cities) %>% addTiles() %>%
  addMapkeyMarkers(lng = ~Long, lat = ~Lat,
                    label = ~City,
                    icon = makeMapkeyIcon(icon = "buddhism",
                                          color = "red",
                                          iconSize = 30,
                                          htmlCode = c('&#57347;&#xe003;'),
                                          boxShadow = FALSE,
                                          background = "transparent"))


icon.pop <- mapkeyIcons(color = ifelse(cities$Pop < 500000, "blue", "red"),
                        iconSize = ifelse(cities$Pop < 500000, 20, 50))

leaflet(cities) %>% addTiles() %>%
  addMapkeyMarkers(lng = ~Long, lat = ~Lat,
                   label = ~City,
                   icon = icon.pop)

# Make a list of icons
iconSet = mapkeyIconList(
  blue = makeMapkeyIcon(icon = "traffic_signal",
                        color = "#0000ff",
                        iconSize = 12,
                        boxShadow = FALSE,
                        background = "transparent"),
  red = makeMapkeyIcon(icon = "buddhism",
                          color = "red",
                          iconSize = 12,
                          boxShadow = FALSE,
                          background = "transparent")
)

leaflet(cities) %>% addTiles() %>%
  addMapkeyMarkers(lng = ~Long, lat = ~Lat,
                  label = ~City,
                  labelOptions = rep(labelOptions(noHide = T), nrow(cities)),
                  icon = ~iconSet[PopCat] )



leaflet(cities) %>% addTiles() %>%
  addMapkeyMarkers(lng = ~Long, lat = ~Lat,
                   label = ~City,
                   clusterOptions = markerClusterOptions(),
                   icon = ~iconSet[PopCat] )
