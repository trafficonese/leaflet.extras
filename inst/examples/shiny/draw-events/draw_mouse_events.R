library(leaflet)
library(leaflet.extras)
library(shiny)

ui <- fluidPage(
  leafletOutput('map'),
  actionButton("clearoverlays", "Clear red overlays"),
  splitLayout(cellWidths = rep("33%", 3),
              verbatimTextOutput('summary_shape'),
              verbatimTextOutput('summary_marker'),
              verbatimTextOutput('summary_polyline')
  )
)

server <- function(input, output, session) {
  output$summary_shape <- renderPrint({
    event <- req(input$map_shape_draw_click)
    if ("radius" %in% names(event)) {
      leafletProxy("map") %>%
        addCircles(lat = event$lat,
                    lng = event$lng, radius = event$radius,
                    color = "red", group = "overlay",
                    layerId = "shapedrawn")
    } else {
      ltgns <- do.call(rbind, event$latlngs)
      leafletProxy("map") %>%
        addPolygons(lat = unlist(ltgns[,"lat"]),
                    lng = unlist(ltgns[,"lng"]),
                    color = "red", group = "overlay",
                    layerId = "shapedrawn")
    }
    print(event)
  })
  output$summary_marker <- renderPrint({
    event <- req(input$map_marker_draw_click)
    leafletProxy("map") %>%
      addCircleMarkers(lat = event$lat,
                       lng = event$lng,
                       color = "red", group = "overlay",
                       layerId = "shapedrawn")
    print(event)
  })
  output$summary_polyline <- renderPrint({
    event <- req(input$map_polyline_draw_click)
    ltgns <- do.call(rbind, event$latlngs)
    leafletProxy("map") %>%
      addPolylines(lat = unlist(ltgns[,"lat"]),
                  lng = unlist(ltgns[,"lng"]),
                  color = "red", group = "overlay",
                  layerId = "shapedrawn")
    print(event)
  })

  observeEvent(input$clearoverlays, {
    leafletProxy("map") %>%
      clearGroup("overlay")
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(10, 10, 4) %>%
      addDrawToolbar(
        targetGroup = 'draw')
  })
}
shinyApp(ui, server)
