library(shiny)
library(leaflet)
library(leaflet.extras)

## Load Tangram-JS in debg mode
options("leaflet.extras.minified" = FALSE)

## File is in /www folder. (Enter your API-Key in the global section)
scene <- "scene.yaml"

ui <- fluidPage(leafletOutput("map"))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      addTangram(scene = scene, layerId = "tangramID", group = "tangram",
                 options = list(attribution = 'Tangram JS',
                                introspection = TRUE,
                                modifyScrollWheel = TRUE,
                                modifyZoomBehavior = TRUE,
                                webGLContextOptions = list(
                                  preserveDrawingBuffer = TRUE,
                                  antialias = FALSE),
                                postUpdate = htmlwidgets::JS("function(didRender) {console.log('postUpdate!');
                                                             if (didRender) {console.log('new frame rendered!');}}"))) %>%
      addCircleMarkers(data = breweries91, group = "brews") %>%
      setView(11, 49.4, 14) %>%
      addLayersControl(baseGroups = c("tangram", "base"),
                       overlayGroups = c("brews"))
  })
}

shinyApp(ui, server)
