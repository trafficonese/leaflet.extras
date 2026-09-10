library(shiny)
library(leaflet)
library(leaflet.extras)
options(shiny.autoreload = TRUE)

google_key <- Sys.getenv("GOOGLE_MAP_GEOCODING_KEY")
has_key <- nzchar(google_key)

ui <- fluidPage(
  titlePanel("Google search in Shiny (issue #112)"),
  p(
    "OSM and Google search together inside ", code("renderLeaflet()"),
    ". Before the fix, Shiny dropped the Google Maps script",
    " (", em("Ignoring appended content"), ") and only OSM appeared."
  ),
  if (has_key) {
    tags$p(tags$b("API key found"), " in GOOGLE_MAP_GEOCODING_KEY.")
  } else {
    tags$p(
      style = "color:#a94442;",
      "No GOOGLE_MAP_GEOCODING_KEY in the environment. Google search needs a key",
      " with the Maps JavaScript API enabled. OSM search still works."
    )
  },
  leafletOutput("map", height = 600),
  h4("Shiny events"),
  splitLayout(
    cellWidths = c("50%", "50%"),
    div("Search found", verbatimTextOutput("search_found")),
    div("Reverse Google found", verbatimTextOutput("rev_search_found"))
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles(providers$Esri.WorldStreetMap) %>%
      setView(lng = 174.768, lat = -36.852, zoom = 9) %>%
      addSearchOSM(options = searchOptions(
        position = "topleft",
        textPlaceholder = "OSM search",
        autoCollapse = TRUE,
        minLength = 2
      ))

    if (has_key) {
      m <- m %>%
        addSearchGoogle(
          apikey = google_key,
          options = searchOptions(
            position = "topright",
            textPlaceholder = "Google search",
            autoCollapse = TRUE,
            minLength = 2
          )
        ) %>%
        addReverseSearchGoogle(
          apikey = google_key,
          displayText = TRUE,
          showSearchLocation = TRUE,
          showBounds = TRUE,
          showFeature = TRUE
        )
    }
    m
  })

  output$search_found <- renderPrint({
    input$map_search_location_found
  })
  output$rev_search_found <- renderPrint({
    input$map_reverse_search_feature_found
  })
}

shinyApp(ui, server)
