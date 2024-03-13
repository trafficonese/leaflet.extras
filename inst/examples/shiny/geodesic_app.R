library(shiny)
library(leaflet)
library(leaflet.extras)
options(shiny.autoreload = TRUE)

cities_df <- data.frame(
  city = c("Hammerfest", "Calgary", "Los Angeles", "Santiago", "Cape Town", "Tokio", "Barrow"),
  lat = c(70.67, 51.05, 34.05, -33.44, -33.91, 35.69, 71.29),
  lng = c(23.68, -114.08, -118.24, -70.71, 18.41, 139.69, -156.76)
)
cities_df$radius <- runif(nrow(cities_df), 4000, 900000)
cities_df$weight <- runif(nrow(cities_df), 1, 20)
cities_df$opacity  <- runif(nrow(cities_df), 0.1, 1)
cities_df$steps  <- runif(nrow(cities_df), 5, 400)
cities_df$color <- sample(c("green","red","blue","orange","black"), nrow(cities_df), replace = TRUE)

cities_df <- cities_df

ui <- fluidPage(
  leafletOutput("map", height = 600),
  splitLayout(cellWidths = c("30%","30%","30%"),
    div("Stats after Drag", verbatimTextOutput("stats")),
    div("Stats after Click", verbatimTextOutput("click")),
    div("Stats after Over", verbatimTextOutput("over"))
    )
  )

greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(cities_df) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMeasure(primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters") %>%
      addGreatCircles(lng_center = ~lng, lat_center = ~lat,
                      steps = ~steps,
                      # steps = 4,
                      color = ~color,
                      radius = ~radius,
                      layerId = ~paste0("ID_",city),
                      fill = T,
                      wrap = FALSE,
                      showStats = T,
                      statsFunction = NULL,
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
                      highlightOptions = highlightOptions(weight = 8, opacity = 1),
                      markerOptions = markerOptions(draggable = TRUE, title = "DRAG ME Title"))
      # addGeodesicPolylines(lng = ~lng, lat = ~lat, weight = 2, color = "red",
      #                      steps = 50, opacity = 1) %>%
      # addCircleMarkers(lat = ~lat, lng = ~lng, radius = 3, stroke = FALSE,
      #                  layerId = ~paste0(city,"_asdasd"),
      #                  fillColor = "black", fillOpacity = 1)
  })
  output$stats <- renderPrint({
    stats <- req(input$map_geodesic_stats)
    print(stats)
  })
  output$click <- renderPrint({
    click <- req(input$map_geodesic_click)
    print(click)
  })
}
shinyApp(ui, server)
