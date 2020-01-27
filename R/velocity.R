velocityDependencies <- function() {
  list(
    htmlDependency(
      "leaflet.velocity", "1.0.0",
      src = system.file("htmlwidgets/build/lfx-velocity", package = "leaflet.extras"),
      script = c("leaflet-velocity.js",
                 "leaflet-velocity-bindings.js"),
      stylesheet = "leaflet-velocity.css"
    )
  )
}

#' Add Velocity Animation
#'
#' @param map a map widget
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{clearGroup} and \code{addLayersControl} purposes). Human-friendly
#'   group names are permitted–they need not be short, identifier-style names.
#'   Any number of layers and even different types of layers (e.g. markers and
#'   polygons) can share the same group name.
#' @param content a JSON File respresenting the velocity data or a URL pointing
#'   to such a JSON file.
#' @param options see \code{\link{velocityOptions}}
#' @description Add velocity animated data to leaflet. Based on the
#'  \href{https://github.com/danwild/leaflet-velocity}{leaflet-velocity plugin}
#' @export
#' @family Velocity Plugin
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras)
#' content <- system.file("examples/velocity/wind-global.json", package = "leaflet.extras")
#' leaflet() %>%
#'   addTiles(group = "base") %>%
#'   addLayersControl(baseGroups = "base", overlayGroups = "velo") %>%
#'   addVelocity(content = content, group = "velo", layerId = "veloid")
#' }
addVelocity <- function(map, layerId = NULL, group = NULL,
                        content = NULL, options = velocityOptions()) {

  ## Check Content
  if (is.null(content)) stop("The content is empty. Please include a JSON or a URL for a specific JSON")
  if (inherits(content, "character")) {
    # grepl("https:", content) || grepl("http:", content)
    content <- jsonlite::fromJSON(content)
    content <- jsonlite::toJSON(content)
  } else if (inherits(content, "data.frame")) {
    content <- jsonlite::toJSON(content)
  } else if (inherits(content, "json")) {
  } else {
    stop("Content is does not point to a JSON file nor is it a data.frame")
  }

  map$dependencies <- c(map$dependencies, velocityDependencies())

  invokeMethod(
    map, NULL, "addVelocity",
    layerId, group, content, options
  )
}


#' velocityOptions
#' @description Define further options for the velocity layer.
#' @param speedUnit Could be 'm/s' for meter per second, 'k/h' for kilometer
#'   per hour or 'kt' for knots
#' @param minVelocity velocity at which particle intensity is minimum
#' @param maxVelocity velocity at which particle intensity is maximum
#' @param velocityScale scale for wind velocity
#' @param colorScale A vector of hex colors or an RGB matrix
#' @param ... Further arguments passed to the Velocity layer and Windy.js.
#'   For more information, please visit \href{https://github.com/danwild/leaflet-velocity}{leaflet-velocity plugin}
#' @export
#' @family Velocity Plugin
velocityOptions <- function(speedUnit = c("m/s", "k/h", "kt"),
                            minVelocity = 0,
                            maxVelocity = 10,
                            velocityScale = 0.005,
                            colorScale = NULL,
                            ...){
  if (!is.null(colorScale) && is.matrix(colorScale)) {
    colorScale <- as.matrix(
      paste0("rgb(", apply(colorScale, 1, function(x)
        paste(x, collapse = ",")), ")"))
  }
  speedUnit <- match.arg(speedUnit)
  list(
    speedUnit = speedUnit,
    minVelocity = minVelocity,
    maxVelocity = maxVelocity,
    velocityScale = velocityScale,
    colorScale = colorScale,
    ...
  )
}

#' removeVelocity
#' @param map the map widget
#' @param group the group to remove
#' @export
#' @family Velocity Plugin
removeVelocity <- function(map, group){
  invokeMethod(map, NULL, "removeVelocity", group)
}
