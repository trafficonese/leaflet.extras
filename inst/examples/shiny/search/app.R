library(leaflet)
library(leaflet.extras)
library(shiny)

ui <- leafletOutput("leafmap")

server <- function(input, output, session) {
  output$leafmap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addSearchOSM(
        options = searchOSMOptions(
          position = 'topleft'))
  })

}

shinyApp(ui, server)
