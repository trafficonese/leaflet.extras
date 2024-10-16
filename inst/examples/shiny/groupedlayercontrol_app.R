library(shiny)
library(leaflet)
library(leaflet.extras)
options(shiny.autoreload = TRUE)

ui <- fluidPage(
  titlePanel("GroupedLayerControls"),
  tags$head(tags$style("
    .btns {
      width: 100%;
      word-wrap: break-word;
      white-space: normal;
    }
    .btns button {
      margin-bottom: 35px;
      display: block;
    }
  ")),
  splitLayout(
    cellWidths = c("35%", "65%"),
    div(class="btns",
        div(tags$b(HTML("Add 2 new Layers ('Markers6', 'Markers7') to the map, <br>add 1 to an existing legend group and one to a new group"))),
        actionButton("addlayer", "Add Layers"),
        div(tags$b("Add a new Baselayer ('CartoDB Darkmode')")),
        actionButton("addbase", "Add Baselayer"),
        div(tags$b("Remove and Clear a layer from the map and the GroupedLayersControl")),
        actionButton("remlayer6", "Remove 'Markers6' Layer"),
        actionButton("remlayer7", "Remove 'Markers7' Layer"),
        div(tags$b("Remove and Clear a baselayer from the map and the GroupedLayersControl (group = CartoDB-Dark)")),
        actionButton("rembase", "Remove Baselayer"),
        div(tags$b("Remove the GroupedLayersControl")),
        actionButton("rem", "Remove GroupedLayersControl"),
    ),
    div(
      leafletOutput("map", height = 800)
    )
  )
)

server <- function(input, output, session) {
  ## Add some base and overlay layers and a GroupedLayersControl
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "OpenStreetMap") %>%
      addProviderTiles("CartoDB", group = "CartoDB") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "red", group = "Markers2") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color="green", group = "Markers1") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color="yellow", group = "Markers3") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "lightblue", group = "Markers4") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "purple", group = "Markers5") %>%
      addGroupedLayersControl(
        baseGroups = c(list("Base1" = "OpenStreetMap")),
        overlayGroups = list("Layergroup_2" = c("Markers5","Markers4"),
                             "Layergroup_1" = c("Markers2","Markers1","Markers3")),
        position = "topright",
        options = groupedLayersControlOptions(groupCheckboxes = T,
                                              collapsed = F,
                                              groupsExpandedClass = "glyphicon glyphicon-chevron-down",
                                              groupsCollapsedClass = "glyphicon glyphicon-chevron-right",
                                              groupsCollapsable = T,
                                              sortLayers = F,
                                              sortGroups = F,
                                              sortBaseLayers = F,
                                              exclusiveGroups = "Layergroup_1")
      )
  })
  observeEvent(input$addlayer, {
    leafletProxy("map") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
                       color = "blue", group = "Markers6") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
                       color = "black", group = "Markers7") %>%
      addGroupedOverlay("Markers6", "Markers6", "Layergroup_2") %>%
      addGroupedOverlay("Markers7", "Markers7 (layername)", "New_Layergroup")
  })
  observeEvent(input$addbase, {
    leafletProxy("map") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "CartoDB-Dark", layerId = "cartodbid") %>%
      addGroupedBaseLayer("CartoDB-Dark", "CartoDB Darkmode")
  })
  observeEvent(input$remlayer6, {
    leafletProxy("map") %>%
      clearGroup("Markers6") %>%
      removeGroupedOverlay("Markers6")
  })
  observeEvent(input$remlayer7, {
    leafletProxy("map") %>%
      clearGroup("Markers7") %>%
      removeGroupedOverlay("Markers7")
  })
  observeEvent(input$rembase, {
    leafletProxy("map") %>%
      clearGroup("Markers7") %>%
      leaflet::removeTiles("cartodbid") %>%
      removeGroupedOverlay("CartoDB-Dark")
  })
  observeEvent(input$rem, {
    leafletProxy("map") %>%
      removeGroupedLayersControl()
  })
}
shinyApp(ui, server)

