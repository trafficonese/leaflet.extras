library(leaflet.extras)
library(shiny)

ui <- fluidPage(
  actionButton("delete","Remove the Draw Toolbar"),
  actionButton("deleteandclear","Remove the Draw Toolbar and cleanFeatures=T"),
  leafletOutput("leafmap")

)

awesomeicon <- leaflet::makeAwesomeIcon(
  icon = "ios-close", iconColor = "black",
  library = "ion", markerColor = "green"
)
drawmark <- drawMarkerOptions(
  zIndexOffset = 10, repeatMode = TRUE,
  markerIcon = awesomeicon
)

server <- function(input, output, session) {
  output$leafmap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addDrawToolbar(
        markerOptions = drawmark,
        toolbar = toolbarOptions(
          actions = list(title = "Cancel it", text = "Cancel!"),
          finish = list(title = "I'm Done", text = "Done"),
          undo = list(title = "Delete last one", text = "Undo last"),
          buttons = list(polyline     = "Draw a nice polyline",
                         polygon      = "Draw a nice polygon",
                         rectangle    = "Draw a nice rectangle",
                         circle       = "Draw a nice circle",
                         marker       = "Draw a nice marker",
                         circlemarker = "Draw a nice circlemarker")
        ),
        handlers =  handlersOptions(
          polyline = list(error = "<strong>Error:</strong> shape edges cannot cross!",
                          tooltipStart = "Click to start drawing a line. &#128512;",
                          tooltipCont  = "Click to start drawing a line. &#128512;",
                          tooltipEnd   = "Click to start drawing a line. &#128512;"),
          polygon = list(tooltipStart  = "Click to start drawing a shape. &#128512;",
                         tooltipCont   = "Click to start drawing a shape. &#128512;",
                         tooltipEnd    = "Click to start drawing a shape. &#128512;"),
        ),
        editOptions = editToolbarOptions())
  })

  observeEvent(input$delete, {
    leafletProxy("leafmap") %>%
      removeDrawToolbar(clearFeatures = FALSE)
  })

  observeEvent(input$deleteandclear, {
    leafletProxy("leafmap") %>%
      removeDrawToolbar(clearFeatures = TRUE)
  })

  # Start of Drawing
  observeEvent(input$leafmap_draw_start, {
    print("Start of drawing")
    print(input$leafmap_draw_start)
  })

  # Stop of Drawing
  observeEvent(input$leafmap_draw_stop, {
    print("Stopped drawing")
    print(input$leafmap_draw_stop)
  })

  # New Feature
  observeEvent(input$leafmap_draw_new_feature, {
    print("New Feature")
    print(input$leafmap_draw_new_feature)
  })

  # Edited Features
  observeEvent(input$leafmap_draw_edited_features, {
    print("Edited Features")
    print(input$leafmap_draw_edited_features)
  })

  # Deleted features
  observeEvent(input$leafmap_draw_deleted_features, {
    print("Deleted Features")
    print(input$leafmap_draw_deleted_features)
  })

  # We also listen for draw_all_features which is called anytime
  # features are created/edited/deleted from the map
  observeEvent(input$leafmap_draw_all_features, {
    print("All Features")
    print(input$leafmap_draw_all_features)
  })
}

shinyApp(ui, server)
