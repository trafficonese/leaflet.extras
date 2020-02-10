tangram_deps <- function(mini = FALSE) {
  list(
    htmlDependency(
      "tangram", "1.0.0",
      src = system.file("htmlwidgets/build/lfx-tangram", package = "leaflet.extras"),
      script = c(ifelse(mini, "tangram.min.js", "tangram.js"),
                 "leaflet.tangram.binding.js"))
  )
}


#' Adds a Tangram layer to a Leaflet map in a Shiny App.
#'
#' @param map A leaflet map widget
#' @param scene Path to a required \bold{.yaml} or \bold{.zip} file. The file must be in the
#'   /www folder of a shinyApp. See the
#'   \href{https://github.com/tangrams/tangram}{Tangram repo} or the
#'   \href{https://tangrams.readthedocs.io/en/latest/}{Tangram docs} for further information
#'   on how to edit such a .yaml file.
#' @param layerId A layer ID
#' @param group The name of the group the newly created layer should belong to
#'   (for \code{\link{clearGroup}} and \code{\link{addLayersControl}} purposes).
#' @param options A list of further options. See the app in the \code{examples/tangram} folder
#'   or the \href{https://tangrams.readthedocs.io/en/latest/Overviews/Tangram-Overview/#leaflet}{docs}
#'   for further information.
#' @export
#' @examples \dontrun{
#' library(shiny)
#' library(leaflet)
#' library(leaflet.extras)
#'
#' ## In the /www folder of the ShinyApp. Must contain the Nextzen API-key
#' scene <- "scene.yaml"
#'
#' ui <- fluidPage(leafletOutput("map"))
#'
#' ## The JS-source can be loaded in an unminified version with the options command below.
#' # options("leaflet.extras.minified" = FALSE)
#'
#' server <- function(input, output, session) {
#'   output$map <- renderLeaflet({
#'     leaflet() %>%
#'       addTiles(group = "base") %>%
#'       addTangram(scene = scene, group = "tangram") %>%
#'       addCircleMarkers(data = breweries91, group = "brews") %>%
#'       setView(11, 49.4, 14) %>%
#'       addLayersControl(baseGroups = c("tangram", "base"),
#'                        overlayGroups = c("brews"))
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
addTangram <- function(map, scene = NULL, layerId = NULL, group = NULL,
                       options = NULL) {

  mini <- getOption("leaflet.extras.minified", default = TRUE)
  map$dependencies <- c(map$dependencies, tangram_deps(mini))

  if ((is.null(scene) || !is.character(scene) || (!gsub(".*\\.", "", scene) %in% c("yaml", "zip")))) {
    stop("The scene must point to a valid .yaml or .zip file.\n",
         "See the documentation for further information.")
  }
  if (!requireNamespace("shiny")) {
    stop("Package `shiny` must be loaded for Tangram")
  }
  shiny::addResourcePath("tangram", paste0(getwd(), "/www"))
  scene <- basename(scene)

  options <- leaflet::filterNULL(c(scene = scene,
                                   options))

  invokeMethod(map, getMapData(map), "addTangram",
               layerId, group, options)
}


