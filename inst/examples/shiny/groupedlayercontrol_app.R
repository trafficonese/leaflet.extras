library(shiny)
library(leaflet)
library(leaflet.extras)

ui <- fluidPage(
  leafletOutput("map")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "OpenStreetMap") %>%
      addProviderTiles("CartoDB", group = "CartoDB") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color="green", group = "Markers1") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "red", group = "Markers2") %>%
      addGroupedLayersControl(
        baseGroups = c("OpenStreetMap", "CartoDB"),
        overlayGroups = c("Markers1","Markers2")
      )
  })
}
shinyApp(ui, server)
