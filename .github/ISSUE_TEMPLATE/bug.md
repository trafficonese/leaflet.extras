---
name: Bug
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''

---

Please briefly describe your problem and what output you expect. If you have a question, please try using stackoverflow https://stackoverflow.com first.

Please try to include a minimal reproducible example.

Leaflet-Plugin Bug
```r
library(leaflet)
library(leaflet.extras)
leaflet()  %>% 
  addTiles()
```

Shiny-specific Bug
```r

library(shiny)  
library(leaflet)
library(leaflet.extras)

ui <- fluidPage(
  leafletOutput("map")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>% 
      addTiles()
  })
}
shinyApp(ui, server)
```
