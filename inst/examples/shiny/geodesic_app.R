## Libs + Data ##########################
library(shiny)
library(leaflet)
library(leaflet.extras)
# install.packages("leaflet.extras")
options(shiny.autoreload = TRUE)

cities_df_all <- data.frame(
  city = c("Hammerfest", "Calgary", "Los Angeles", "Santiago", "Cape Town", "Tokio", "Barrow"),
  lat = c(70.67, 51.05, 34.05, -33.44, -33.91, 35.69, 71.29),
  lng = c(23.68, -114.08, -118.24, -70.71, 18.41, 139.69, -156.76)
)
cities_df_all$radius <- runif(nrow(cities_df_all), 4000, 900000)
cities_df_all$weight <- runif(nrow(cities_df_all), 1, 20)
cities_df_all$opacity  <- runif(nrow(cities_df_all), 0.1, 1)
cities_df_all$steps  <- runif(nrow(cities_df_all), 5, 400)
cities_df_all$color <- sample(c("green","red","blue","orange","black"), nrow(cities_df_all), replace = TRUE)
cities_df <- cities_df_all[1:4,]

greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

## UI ##########################
ui <- fluidPage(
  ## Actions ###########
  div(
    actionButton("add", "Add Geodesic via Proxy"),
    actionButton("rem", "Remove by ID"),
    actionButton("rema", "Remove All"),
    actionButton("cle", "Clear by Group"),
    actionButton("show", "Show by Group"),
    actionButton("hide", "Hide by Group"),
  ),
  leafletOutput("map", height = 600),
  ## Event Outputs ###########
  h4("Leaflet Geodesic Events"),
  splitLayout(cellWidths = c("30%","30%","30%"),
    div("Stats after Drag", verbatimTextOutput("drag")),
    div("Stats after Click", verbatimTextOutput("click")),
    div("Stats after Over", verbatimTextOutput("over"))
    ),
  h4("Leaflet Events"),
  splitLayout(cellWidths = c("30%","30%","30%"),
              div("Mouseout", verbatimTextOutput("leaf_out")),
              div("Click", verbatimTextOutput("leaf_click")),
              div("Mouseover", verbatimTextOutput("leaf_over"))
  )
)
## END - UI ##########################

## Server ##########################
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(cities_df) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMeasure(primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters") %>%
      addGreatCircles(lng_center = ~lng, lat_center = ~lat,
                      group = "circles",
                      steps = ~steps,
                      # steps = 4,
                      color = ~color,
                      radius = ~radius,
                      layerId = ~paste0("ID_",city),
                      wrap = FALSE,
                      fill = T,
                      showStats = T,
                      # statsFunction = NULL,
                      # statsFunction = JS("function(stats) {
                      #                      return('<h4>Custom Stats Info</h4>' +
                      #                         '<div>Vertices:  ' + stats.vertices + '</div>' +
                      #                         '<div>Distance:  ' + stats.totalDistance + '</div>')
                      #                    }
                      #                    "),
                      # popup = NULL,
                      popup = ~paste0("<h4>",city,"</h4>
                                      <div>radius = ",radius,"</div>
                                      <div>steps = ",steps,"</div>
                                      "),
                      label = ~paste(city, "-", color),
                      # opacity = ~opacity,
                      opacity = 0.2,
                      # weight = ~weight,
                      weight = 4,
                      smoothFactor = 3,
                      dashArray = c(5, 10),
                      icon = greenLeafIcon,
                      markerOptions = markerOptions(draggable = TRUE, title = "DRAG ME Title"),
                      # markerOptions = NULL,
                      highlightOptions = highlightOptions(weight = 8, opacity = 1)
                      ) %>%
      addLayersControl(overlayGroups = c("circles","circles_added"))

      # addGeodesicPolylines(lng = ~lng, lat = ~lat, weight = 2, color = "red",
      #                      steps = 50, opacity = 1) %>%
      # addCircleMarkers(lat = ~lat, lng = ~lng, radius = 3, stroke = FALSE,
      #                  layerId = ~paste0(city,"_asdasd"),
      #                  fillColor = "black", fillOpacity = 1)
  })

  ## Event Outputs ###########
  ## Geodesic
  output$drag <- renderPrint({
    input$map_geodesic_stats
  })
  output$click <- renderPrint({
    input$map_geodesic_stats
  })
  output$over <- renderPrint({
    input$map_geodesic_mouseover
  })

  ## Leaflet
  output$leaf_click <- renderPrint({
    input$map_shape_click
  })
  output$leaf_over <- renderPrint({
    input$map_shape_mouseover
  })
  output$leaf_out <- renderPrint({
    input$map_shape_mouseout
  })

  ## Actions ###########
  observeEvent(input$add, {

    leafletProxy("map") %>%
      addGreatCircles(data = cities_df_all[5:7,],
                      lng_center = ~lng, lat_center = ~lat,
                    group = "circles_added",
                    steps = ~steps,
                    # steps = 4,
                    color = ~color,
                    radius = ~radius,
                    layerId = ~paste0("ID_",city),
                    wrap = FALSE,
                    fill = T,
                    showStats = T,
                    statsFunction = JS("function(stats) {
                                         return('<h4>Custom Stats Info</h4>' +
                                            '<div>Vertices:  ' + stats.vertices + '</div>' +
                                            '<div>Distance:  ' + stats.totalDistance + '</div>')
                                       }
                                       "),
                    popup = ~paste0("<h4>",city,"</h4>
                                      <div>radius = ",radius,"</div>
                                      <div>steps = ",steps,"</div>
                                      "),
                    label = ~paste(city, "-", color),
                    opacity = 1,
                    dashArray = c(5, 10),
                    icon = greenLeafIcon,
                    markerOptions = markerOptions(draggable = TRUE, title = "DRAG ME Title"),
                    highlightOptions = highlightOptions(weight = 8, opacity = 1)
    )
  })
  observeEvent(input$rem, {
    leafletProxy("map") %>%
      leaflet::removeShape(layerId = paste0("ID_",cities_df$city[sample(1:7, sample(1:4,1))]))
  })
  observeEvent(input$rema, {
    leafletProxy("map") %>%
      leaflet::clearShapes()
      # leaflet::clearMarkers()
  })
  observeEvent(input$cle, {
    leafletProxy("map") %>%
      leaflet::clearGroup(group = "circles")
  })
  observeEvent(input$show, {
    leafletProxy("map") %>%
      leaflet::showGroup(group = "circles")
  })
  observeEvent(input$hide, {
    leafletProxy("map") %>%
      leaflet::hideGroup(group = "circles")
  })
}
shinyApp(ui, server)
