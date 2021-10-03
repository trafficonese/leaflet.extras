library(shiny)
library(leaflet)
library(leaflet.extras)

ui <- fluidPage(
  leafletOutput("map"),
  actionButton("action", "removeOpacityControl(layerId)"),
  actionButton("action1", "leaflet::clearControls()")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addWMSTiles(baseUrl = "http://demo.lizardtech.com/lizardtech/iserv/ows",
                  group = "opacitygroup", layers = 'Seattle1890', options = WMSTileOptions(
                    format = "image/png", transparent = TRUE, crs = NULL)) %>%
      addOpacityControl(layerId = "opac", init_opac = 0.5,
                        options = opacityControlOptions(
                          position = "bottomright"
                          ,orientation = "horizontal"
                          ,range = "min"
                          ,animate = 1000
                          ,max = 1000
                        ),
                        opacitygroup = "opacitygroup") %>%
      addControl(HTML("Dummy Control"), position = "bottomright") %>%
      setView(-122.30, 47.59, 10)
  })

  observeEvent(input$action, {
    leafletProxy("map") %>%
      removeOpacityControl("opac")
  })
  observeEvent(input$action1, {
    leafletProxy("map") %>%
      clearControls()
  })
}

shinyApp(ui, server)
