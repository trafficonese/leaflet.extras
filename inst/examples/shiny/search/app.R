library(leaflet.extras)
library(shiny)

ui <- leafletOutput("leafmap")

server <- function(input, output, session) {
  output$leafmap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addSearchOSM(
        options = searchOSMOptions(
          position = "topleft"))
  })

  observeEvent(input$leafmap_search_location_found, {
    print("Location Found")
    print(input$leafmap_search_location_found)
  })

}

shinyApp(ui, server)
