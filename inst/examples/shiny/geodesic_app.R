library(shiny)
library(leaflet)
library(leaflet.extras)

cities_df <- data.frame(
  city = c("Hammerfest", "Calgary", "Los Angeles", "Santiago", "Cape Town", "Tokio", "Barrow"),
  lat = c(70.67, 51.05, 34.05, -33.44, -33.91, 35.69, 71.29),
  lng = c(23.68, -114.08, -118.24, -70.71, 18.41, 139.69, -156.76)
)
cities_df <- cities_df[1,]

ui <- fluidPage(leafletOutput("map", height = 800))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(cities_df) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMeasure(primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters") %>%
      addGreatCircles(lng_center = ~lng, lat_center = ~lat,
                      color = "blue", radius = 4000,
                      weight = 10)
      # addGeodesicPolylines(lng = ~lng, lat = ~lat, weight = 2, color = "red",
      #                      steps = 50, opacity = 1) %>%
      # addCircleMarkers(lat = ~lat, lng = ~lng, radius = 3, stroke = FALSE,
      #                  fillColor = "black", fillOpacity = 1)
  })
}
shinyApp(ui, server)
