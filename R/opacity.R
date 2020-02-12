opacityDependencies <- function(jui = TRUE) {
  scripts <- c("lfx-control-opacity.js",
               "lfx-control-opacity-bindings.js")
  styles <- c("lfx-control-opacity.css")
  if (jui) {
    scripts <- c(scripts, "jquery-ui-1.10.3.custom.min.js")
    styles <- c(styles, "jquery-ui-1.10.3.custom.min.css")
  }

  list(
    htmltools::htmlDependency(
      "leaflet.opacity", "1.0.0",
      src = system.file("htmlwidgets/build/lfx-opacity", package = "leaflet.extras"),
      script = scripts,
      stylesheet = styles
    )
  )
}

#' Add Opacity Control
#' @param map a map widget
#' @param layerId the layer id, needed for \code{\link{removeOpacityControl}}
#' @param opacitygroup the layer group for which the opacity control should be added.
#' @param buttons Should the opacity control buttons be included. Default is TRUE
#' @param slider Should the opacity control slider be included. Default is TRUE
#' @param init_opac Should an initial opacity be set. Default is 0.5.
#' @param options A list of options. See \code{\link{opacityControlOptions}}
#' @description Add Leaflet Opacity Control. Based on the plugin
#'   \href{https://github.com/lizardtechblog/Leaflet.OpacityControls}{leaflet-opacity-control}.
#' @export
#' @family OpacityControl Plugin
#' @examples \dontrun{
#' leaflet() %>%
#'   addTiles() %>%
#'   addWMSTiles(baseUrl = "http://demo.lizardtech.com/lizardtech/iserv/ows",
#'               group = "opacitygroup", layers = 'Seattle1890',
#'               options = WMSTileOptions(format = "image/png", transparent = TRUE)) %>%
#'   addOpacityControl(init_opac = 0.5, opacitygroup = "opacitygroup") %>%
#'   setView(-122.30, 47.59, 10)
#' }
addOpacityControl <- function(map, layerId = NULL,
                              opacitygroup = NULL,
                              buttons = TRUE,
                              slider = TRUE,
                              init_opac = 0.5,
                              options = opacityControlOptions()){

  if (is.null(opacitygroup)) stop("Please include the `group` of the layer ",
                                  "whose opacity you want to control.")
  if (init_opac > 1) init_opac = 1
  if (init_opac < 0 || init_opac == 0) init_opac = 0.01 ## If 0, opacity is set to 1
  if (is.null(buttons) || is.na(buttons)) buttons = FALSE
  if (is.null(slider) || is.na(slider)) slider = FALSE
  if (!slider && !buttons) {
    warning("No opacity controls defined. ",
            "Either set `slider` or `buttons` to TRUE.")
    invisible()
  }

  map$dependencies <- c(map$dependencies, opacityDependencies(slider))
  options = leaflet::filterNULL(options)

  invokeMethod(map, getMapData(map), "addOpacityControl",
               layerId, opacitygroup, buttons, slider, init_opac, options)
}

#' Opacity Control options
#' @param position The position where the opacity control should be added
#' @param orientation The orientation of the slider. Can be `vertical` or `horizontal`
#' @param range Which slider range should be used, either `min` or `max`
#' @param animate The animation of the slider. Can be either `slow` or `fast` or
#'   a number for the duration of the animation, in milliseconds.
#'   For further information see the \href{https://api.jqueryui.com/slider/}{docs}
#'   of the jQuery UI slider.
#' @param max The maximum value of the slider
#' @description Define Opacity Control options
#' @export
#' @family OpacityControl Plugin
opacityControlOptions <- function(position = c("topright","topleft","bottomright","bottomleft"),
                                  orientation = c("vertical", "horizontal"),
                                  range = c("min","max"),
                                  animate = "slow",
                                  max = 100) {
  position = match.arg(position)
  orientation = match.arg(orientation)
  range = match.arg(range)

  list(position = position,
       orientation = orientation,
       range = range,
       animate = animate,
       max = max)
}

#' Remove Opacity Control
#' @param map a map widget
#' @param layerId the layer id
#' @description Removes the opacity control
#' @export
#' @family OpacityControl Plugin
removeOpacityControl <- function(map, layerId) {
  invokeMethod(map, NULL, "removeOpacityControl", layerId)
}
