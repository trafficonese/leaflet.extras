library(shiny)
library(leaflet)
library(leaflet.extras)

content <- system.file("examples/velocity/wind-global.json", package = "leaflet.extras")
# content <- system.file("examples/velocity/water-gbr.json", package = "leaflet.extras")
# content <- system.file("examples/velocity/wind-gbr.json", package = "leaflet.extras")

ui <- fluidPage(
  leafletOutput("map")
  , actionButton("showGroup", "showGroup")
  , actionButton("hideGroup", "hideGroup")
  , actionButton("removeVelocity", "removeVelocity")
  , actionButton("clearGroup", "clearGroup")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      addLayersControl(baseGroups = "base", overlayGroups = "Wind") %>%
      addVelocity(content = content, group = "Wind", layerId = "veloid",
                  options = velocityOptions(
                    position = "bottomright",
                    emptyString = "Nothing to see",
                    speedUnit = "k/h",
                    lineWidth = 2,
                    colorScale = rainbow(12)
      ))
  })
  observeEvent(input$showGroup, {
    leafletProxy("map") %>%
      showGroup("Wind")
  })
  observeEvent(input$hideGroup, {
    leafletProxy("map") %>%
      hideGroup("Wind")
  })
  observeEvent(input$removeVelocity, {
    leafletProxy("map") %>%
      removeVelocity("veloid")
  })
  observeEvent(input$clearGroup, {
    leafletProxy("map") %>%
      clearGroup("Wind")
  })
}

shinyApp(ui, server)
