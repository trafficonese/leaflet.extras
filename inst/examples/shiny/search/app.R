library(leaflet.extras)
library(shiny)

ui <- fluidPage(
  actionButton("remove","remove"),
  leafletOutput("map")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addSearchOSM(
        options = searchOptions(
          position = "topleft"))
  })

  observeEvent(input$remove, {
    leafletProxy("map") %>%
      leaflet.extras::removeSearchOSM()
  })
  observeEvent(input$leafmap_search_location_found, {
    print("Location Found")
    print(input$leafmap_search_location_found)
  })

}

shinyApp(ui, server)
