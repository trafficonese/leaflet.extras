library(leaflet)
library(leaflet.extras)
library(shiny)
library(readr)

topojson <- readr::read_file(
  "https://raw.githubusercontent.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson"
)

ui <- fluidPage(
  titlePanel("Choropleth fill opacity per feature (#53)"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        "opacity_mode",
        "Fill opacity",
        choices = c(
          "Constant 0.7" = "constant",
          "JS: dist_num / 30" = "js",
          "Property dist_num (raw)" = "prop"
        ),
        selected = "js"
      ),
      helpText(
        "Color still maps incident counts.",
        "JS mode scales district number to 0–1 so larger districts are more opaque."
      ),
      width = 3
    ),
    mainPanel(leafletOutput("map", height = 600), width = 9)
  )
)

make_map <- function(opacity_mode) {
  map <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    setView(-75.14, 40, zoom = 11)

  common <- list(
    geojson = topojson,
    valueProperty = "incidents",
    scale = "OrRd",
    mode = "q",
    steps = 5,
    labelProperty = JS(
      "function(feature){return 'District ' + feature.properties.dist_numc +
        ' | incidents: ' + feature.properties.incidents;}"
    ),
    color = "#ffffff",
    weight = 1,
    highlightOptions = highlightOptions(
      fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
      bringToFront = TRUE
    ),
    legendOptions = legendOptions(title = "Incidents", position = "bottomright")
  )

  args <- switch(
    opacity_mode,
    constant = c(common, list(fillOpacity = 0.7)),
    js = c(common, list(
      fillOpacity = JS(
        "function(feature){return Math.min(1, feature.properties.dist_num / 30);}"
      )
    )),
    prop = c(common, list(fillOpacityProperty = "dist_num"))
  )

  do.call(addGeoJSONChoropleth, c(list(map = map), args))
}

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    make_map(input$opacity_mode)
  })
}

shinyApp(ui, server)
