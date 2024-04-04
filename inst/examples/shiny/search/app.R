library(leaflet.extras)
library(shiny)
options(shiny.autoreload = TRUE)

greenLeafIcon <- makeIcon(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
awesomeicon <- leaflet::makeAwesomeIcon(
  icon = "ios-close", iconColor = "black",
  library = "ion", markerColor = "green")

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
      addProviderTiles(providers$CartoDB.Positron,
                       options = tileOptions(noWrap = FALSE)) %>%
      addSearchOSM(options = searchOptions(
        position = "topleft",
        hideMarkerOnCollapse = TRUE,
        marker = list(
          # icon = greenLeafIcon,
          icon = awesomeicon,
          circle = list(
            radius = 50,
            weight = 3,
            color = 'yellow',
            stroke = TRUE,
            fill = TRUE
          )
        ))) %>%
      addReverseSearchOSM(
        showSearchLocation = TRUE,
        showBounds = TRUE,
        showFeature = TRUE,
        fitBounds = TRUE,
        displayText = TRUE,
        group = "revosm",
        marker = list(
          icon = greenLeafIcon
          # icon = awesomeicon
        )
        ,showFeatureOptions = list(
          weight = 7,
          color = "purple",
          dashArray = '2,5',
          fillOpacity = 0.8,
          opacity = 1
        )
        ,showBoundsOptions = list(
          weight = 4,
          color = "orange",
          dashArray = '10,20',
          fillOpacity = 0.1,
          opacity = 1
        )
        ,showHighlightOptions = list(
          opacity = 1,
          fillOpacity = 0.8,
          weight = 9
        )
        ) %>%
      leaflet::addLayersControl(overlayGroups = "revosm")
  })

  output$search_found <- renderPrint({
    print("Location Found")
    print(input$map_search_location_found)
  })
  output$rev_search_found <- renderPrint({
    print("Reverse Search Found")
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
