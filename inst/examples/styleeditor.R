library(shiny)
library(leaflet)
library(leaflet.extras)

ui <- fluidPage(
  actionButton("rem", "Remove")
  , leafletOutput("map", height = 800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(0, 0, 2) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addDrawToolbar(
        targetGroup = "draw",
        editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
      ) %>%
      addLayersControl(
        overlayGroups = c("draw"), options = layersControlOptions(collapsed = FALSE)
      ) %>%
      # add the style editor to alter shapes added to map
      addStyleEditor()
  })

  observeEvent(input$rem, {
    leafletProxy("map") %>%
      removeStyleEditor()
  })
}
shinyApp(ui, server)
