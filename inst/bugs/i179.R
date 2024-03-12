
## libs & data ###################################
library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras)
drawtoolbar = TRUE

## modules ###################################
mod1_ui <- function(id, label, value) {
  ns <- NS(id)
  tabPanel(label, value = value, leafletOutput(ns("map"))
  )
}
mod1_server <- function(input, output, session, parent_session, navid) {
  output$map <- renderLeaflet({
    leaflet() %>% addTiles()
  })
 observe({
   req(parent_session$input$navbarid == navid)
   if (drawtoolbar) {
     leafletProxy("map") %>%
       addDrawToolbar(position="topright",
                      targetGroup = "Sel")
   }
 })
}

## ui ###################################
ui <- navbarPage(id = "navbarid", title = 'DEMO', selected = 1,
                 mod1_ui("mod1", "mod1", 1),
                 mod1_ui("mod2", "mod2", 2)
)

## server ###################################
server <- function(input, output, session) {
  callModule(mod1_server, "mod1", parent_session = session, navid = 1)
  callModule(mod1_server, "mod2", parent_session = session, navid = 2)
}

## Run App ###################################
shinyApp(ui, server)
