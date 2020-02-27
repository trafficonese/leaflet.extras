
library(shiny)
library(shinycssloaders)
library(leaflet)
library(leaflet.extras)


ui <- fluidPage(
  withSpinner(leafletOutput("map")),
  selectInput("scene", "Select Scene", choices = c("Current", "CurrentSize", "A4Landscape", "A4Portrait")),
  textInput("fn", "Filename", value = "map"),
  actionButton("print", "Print Map"),
  actionButton("rem", "removeEasyprint"),
  actionButton("cle", "clearControls")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    input$print
    leaflet()  %>%
      addTiles() %>%
      addEasyprint(options = easyprintOptions(title = 'Give me that map',
                                              position = 'bottomleft',
                                              exportOnly = FALSE,
                                              filename = "mapit",
                                              hideClasses = list("div1","div2"),
                                              customWindowTitle = "Some Fancy Title",
                                              customSpinnerClass = "shiny-spinner-placeholder",
                                              spinnerBgColor = "#b48484"))
  })
  observeEvent(input$print, {
    leafletProxy("map") %>%
      easyprintMap(sizeModes = input$scene, filename = input$fn)
  })
  observeEvent(input$rem, {
    leafletProxy("map") %>%
      removeEasyprint()
  })
  observeEvent(input$cle, {
    leafletProxy("map") %>%
      clearControls()
      # clearGroup("easyprintgroup")
  })
}

shinyApp(ui, server)

#
# (title = 'Print map',
#   position = 'topleft',
#   sizeModes = NULL,
#   defaultSizeTitles = NULL,
#   exportOnly = FALSE,
#   tileLayer = NULL,
#   tileWait = 500,
#   filename = 'map',
#   hidden = FALSE,
#   hideControlContainer = TRUE,
#   hideClasses = list(),
#   customWindowTitle = NULL,
#   spinnerBgColor = '#0DC5C1',
#   customSpinnerClass = 'epLoader')
