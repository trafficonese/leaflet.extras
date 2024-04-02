library(leaflet.extras)
library(shiny)
options(shiny.autoreload = TRUE)

ui <- fluidPage(
  h4("OSM Search")
  , actionButton("clearReverseSearchOSM", "clearReverseSearchOSM")
  , actionButton("set", "Set the Search Text")
  , actionButton("show", "Show ReverseSearch")
  , actionButton("hide", "Hide ReverseSearch")
  , actionButton("removeSearchOSM", "removeSearchOSM ")
  , leafletOutput("map")
  , splitLayout(cellWidths = rep("33%",3)
                , verbatimTextOutput("search_found")
                , verbatimTextOutput("rev_search_found")
                # , verbatimTextOutput("search_found")
                )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addSearchOSM(options = searchOptions(
        position = "topleft",
        hideMarkerOnCollapse = TRUE)) %>%
      addReverseSearchOSM(
        showSearchLocation = TRUE,
        showBounds = FALSE,
        showFeature = TRUE,
        fitBounds = TRUE,
        displayText = TRUE,
        group = "revosm") %>%
      leaflet::addLayersControl(overlayGroups = "revosm")
  })

  output$search_found <- renderPrint({
    print("Location Found")
    print(input$map_search_location_found)
  })
  output$rev_search_found <- renderPrint({
    print("Reverse Search FOund")
    print(input$map_reverse_search_feature_found)
  })


  observeEvent(input$removeSearchOSM, {
    leafletProxy("map") %>%
      removeSearchOSM()
  })
  observeEvent(input$set, {
    leafletProxy("map") %>%
      searchOSMText("California")
  })
  observeEvent(input$show, {
    leafletProxy("map") %>%
      showGroup("revosm")
  })
  observeEvent(input$hide, {
    leafletProxy("map") %>%
      hideGroup("revosm")
  })
  observeEvent(input$clearReverseSearchOSM, {
    leafletProxy("map") %>%
      clearGroup("revosm")
  })

}

shinyApp(ui, server)
