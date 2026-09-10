library(shiny)
library(leaflet)
library(leaflet.extras)

ui <- fluidPage(
  checkboxInput("showlegend", "Show Legend", FALSE),
  leafletOutput("map")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(11, 51, 6) %>%
      # addWMSLegend(
      #   uri = paste0(
      #     "https://www.wms.nrw.de/wms/unfallatlas?request=GetLegendGraphic%26version=1.3.0%26format=image/png%26layer=Personenschaden_5000"
      #   )
      # ) %>%
      addWMSTiles(
        baseUrl = "https://www.wms.nrw.de/wms/unfallatlas?request=GetMap",
        layers = c("Unfallorte","Personenschaden_5000","Personenschaden_250"),
        options = WMSTileOptions(format = "image/png", transparent = TRUE)
      )
  })
  observeEvent(input$showlegend, {
    if (isTRUE(input$showlegend)) {
      leafletProxy("map") %>%
        addWMSLegend(
          uri = "https://www.wms.nrw.de/wms/unfallatlas?request=GetLegendGraphic%26version=1.3.0%26format=image/png%26layer=Personenschaden_5000",
          layerId = "Personenschaden_5000"
        )
    } else {
      leafletProxy("map") %>%
        removeControl(layerId = "Personenschaden_5000")
    }
  })
}
shinyApp(ui, server)
