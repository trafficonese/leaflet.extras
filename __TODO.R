
options(shiny.autorelad = TRUE)
devmode(TRUE)

PROBLEMS

# All Rpubs in Readme not working

# OSM Search not working


# Seach in Shiny
# Warning in renderWidget(instance) :
#   Ignoring appended content; appendContent can't be used in a Shiny render call
library(shiny); library(leaflet); library(leaflet.extras)
ui <- fluidPage(leafletOutput("map", height=800))
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>% addProviderTiles(providers$Esri.WorldStreetMap) %>%
      addSearchGoogle(options = searchOptions(textPlaceholder = "Custom Google Search"))
  })}
shinyApp(ui, server)



# Input to asJSON(keep_vec_names=TRUE) is a named vector. In a future version of jsonlite, this option will not be supported, and named vectors will be translated into arrays instead of objects. If you want JSON object output, please use a named list instead. See ?toJSON.
library(shiny);library(leaflet);library(leaflet.extras)
ui <- fluidPage(leafletOutput("map"))
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(quakes) %>% addTiles() %>%
      addWebGLHeatmap(lng = ~long, lat = ~lat, size = 60000, gradientTexture = "deep-sea")
})}
shinyApp(ui, server)


## "leaflet.heat": "bhaskarvk/Leaflet.heat#60cf4c4",   ?? its working with Leaflet/Leaflet.heat
