sidebysideDependencies <- function() {
  list(
    htmlDependency(
      "leaflet.sidebyside", "1.0.0",
      src = system.file("htmlwidgets/build/lfx-side-by-side", package = "leaflet.extras"),
      script = c("lfx-side-by-side.js",
                 "lfx.addSidebyside.bindings.js")
    )
  )
}

#' Add Side by Side View
#'
#' @param map a map widget
#' @param layerId the layer id, needed for \code{\link{removeSidebyside}}
#' @param leftId the \code{layerId} of the Tile layer that should be
#'   visible on the \strong{left} side
#' @param rightId the \code{layerId} of the Tile layer that should be
#'   visible on the \strong{right} side
#' @param options A list of options. Currently only \code{thumbSize} and
#'   \code{padding} can be changed.
#' @description Add Leaflet Sidebyside View. Based on the plugin
#'   \href{https://github.com/digidem/leaflet-side-by-side}{leaflet-side-by-side}.
#'   The plugin works with Panes, see the example.
#' @note It is currently not working correctly if the \code{baseGroups} are defined in
#'   \code{\link[leaflet]{addLayersControl}}.
#' @export
#' @family Sidebyside Plugin
#' @examples \dontrun{
#' library(shiny)
#' library(leaflet)
#' library(leaflet.extras)
#'
#' ui <- fluidPage(
#'   leafletOutput("map")
#' ,actionButton("removeSidebyside", "removeSidebyside")
#' )
#'
#' server <- function(input, output, session) {
#'   output$map <- renderLeaflet({
#'     leaflet(quakes) %>%
#'       addMapPane("left", zIndex = 0) %>%
#'       addMapPane("right", zIndex = 0) %>%
#'       addTiles(group = "base", layerId = "baseid",
#'                options = pathOptions(pane = "right")) %>%
#'       addProviderTiles(providers$CartoDB.DarkMatter, group="carto", layerId = "cartoid",
#'                        options = pathOptions(pane = "left")) %>%
#'       addCircleMarkers(data = breweries91[1:15,], color = "blue", group = "blue",
#'                        options = pathOptions(pane = "left")) %>%
#'       addCircleMarkers(data = breweries91[15:20,], color = "yellow", group = "yellow") %>%
#'       addCircleMarkers(data = breweries91[15:30,], color = "red", group = "red",
#'                        options = pathOptions(pane = "right")) %>%
#'       addLayersControl(overlayGroups = c("blue","red", "yellow")) %>%
#'       addSidebyside(layerId = "sidecontrols",
#'                     rightId = "baseid",
#'                     leftId = "opencycle")
#'   })
#'   observeEvent(input$removeSidebyside, {
#'     leafletProxy("map") %>%
#'       removeSidebyside("sidecontrols")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
addSidebyside <- function(map, layerId = NULL,
                          leftId = NULL, rightId = NULL,
                          options = list(thumbSize = 42,
                                         padding = 0)){

  map$dependencies <- c(map$dependencies, sidebysideDependencies())
  options = leaflet::filterNULL(c(options))

  invokeMethod(map, NULL, "addSidebyside",
               layerId, leftId, rightId, options)
}

#' removeSidebyside
#' @export
#' @param map a map widget
#' @param layerId the layer id of the \code{\link{addSidebyside}} layer
#' @family Sidebyside Plugin
removeSidebyside <- function(map, layerId = NULL){
  invokeMethod(map, NULL, "removeSidebyside", layerId)
}
