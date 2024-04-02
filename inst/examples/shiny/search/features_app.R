library(shiny)
library(leaflet)
library(leaflet.extras)

cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

ui <- fluidPage(
  leafletOutput("map"),
  actionButton("clearsearchmarker", "Clear Search Marker")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(cities) %>% addProviderTiles(providers$OpenStreetMap) %>%
      addCircles(lng = ~Long, lat = ~Lat, weight = 1, fillOpacity = 0.5,
                 radius = ~sqrt(Pop) * 10,
                 popup = ~City, label = ~City,
                 group = "cities") %>%
      addSearchFeatures(
        targetGroups = "cities",options = searchFeaturesOptions())
  })

  observeEvent(input$clearsearchmarker, {
    leafletProxy("map") %>%
      clearSearchFeatures()
  })
}
shinyApp(ui, server)
