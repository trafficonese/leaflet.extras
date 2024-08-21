library(shiny)
library(leaflet)
library(leaflet.extras)
options(shiny.autoreload = TRUE)

ui <- fluidPage(
  tags$head(tags$style(".leaflet-control-layers-group-name{
                          font-weight: 800 !important;
                       }")),
  actionButton("addlayer", "Add a Layer to the Map and the LayersControl"),
  actionButton("rem", "Remove the LayersControl"),
  leafletOutput("map", height = 800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "OpenStreetMap") %>%
      addProviderTiles("CartoDB", group = "CartoDB") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color="green", group = "Markers1") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "red", group = "Markers2") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color="yellow", group = "Markers3") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "blue", group = "Markers4") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "purple", group = "Markers5") %>%
      addGroupedLayersControl(
        baseGroups = c("CartoDB","OpenStreetMap"),
        overlayGroups = list("Markers1+2 (exclusive)" = c("Markers1","Markers2","Markers3"),
                             "Markers-Group" = c("Markers4","Markers5")),
        position = "topright",
        options = groupedLayersControlOptions(groupCheckboxes = TRUE,
                                              collapsed = FALSE,
                                              exclusiveGroups = "Markers1+2 (exclusive)")
                                              # exclusiveGroups = c("Markers1+2 (exclusive)","Markers-Group"))
      )
  })
  observeEvent(input$addlayer, {
    leafletProxy("map") %>%
      addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
                       color = "lightblue", group = "Markers6") %>%
      addGroupedOverlay("Markers6", "Markers6", "Markers-Group")
  })
  observeEvent(input$rem, {
    leafletProxy("map") %>%
      removeGroupedLayersControl()
  })
}
shinyApp(ui, server)

