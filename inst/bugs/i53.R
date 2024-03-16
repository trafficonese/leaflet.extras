library(shiny)
library(leaflet)
library(leaflet.extras)
options(shiny.autoreload =TRUE)

topojson <- readr::read_file("https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson")

ui <- fluidPage(
  leafletOutput("map", height = 800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(-75.14, 40, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addGeoJSONChoropleth(
        topojson,
        valueProperty ='incidents',
        # labelProperty ='location',
        # labelProperty =JS('function(feature) {
        #     return "Location:<br>" + feature.properties.location
        # }'),
        # # popupProperty ='incidents',
        popupProperty = JS('function(feature) {
            return "<table>" +
             "<tr><th>Location</th><td>" + feature.properties.location + "</td></tr>" +
             "<tr><th>Area (sq mi)</th><td>" + feature.properties.area_sqmi + "</td></tr>" +
             "<tr><th>District Number</th><td>" + feature.properties.dist_numc + "</td></tr>" +
             "<tr><th>Fill Opacity Value</th><td>" + (feature.properties.dist_num / 10) + "</td></tr>" +
             "<tr><th>Feature ID</th><td>" + feature.properties._feature_id + "</td></tr>" +
             "<tr><th>Perimeter</th><td>" + feature.properties.perimeter + "</td></tr>" +
             "<tr><th>Phone</th><td>" + feature.properties.phone + "</td></tr>" +
             "<tr><th>Incidents</th><td>" + feature.properties.incidents + "</td></tr>" +
            "</table>";
        }'),
        scale = c("red","red"),
        fillOpacityProperty = JS("function(feature){debugger; return (
          feature.properties._feature_id / 15);
        }"),
        # fillOpacity = 1,
        highlightOptions = highlightOptions(opacity = 1, weight = 3, fill="blue")
      )
  })
}
shinyApp(ui, server)
