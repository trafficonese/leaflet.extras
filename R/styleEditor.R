styleEditorDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "style-editor",version = "0.1.6",
      system.file("htmlwidgets/lib/style-editor", package = "leaflet.extras"),
      script = c('Leaflet.StyleEditor.min.js', 'styleEditor-bindings.js'),
      stylesheet = c('Leaflet.StyleEditor.min.css')
    )
  )
}

#' Add style editor
#' @param map the map widget
#' @param position position of the control
#' @param openOnLeafletDraw whether to open automatically when used with \code{\link{addDrawToolbar}}()
#' @param useGrouping Should be false to work with \code{\link{addDrawToolbar}}()
#' @param ... other options. See \href{https://github.com/dwilhelm89/Leaflet.StyleEditor/blob/master/src/javascript/Leaflet.StyleEditor.js}{plugin code}
#' @rdname style-editor
#' @export
addStyleEditor <- function(
  map,
  position = c('topleft','topright','bottomleft','bottomright'),
  openOnLeafletDraw = TRUE, useGrouping = FALSE,
  ...) {

  map$dependencies <- c(map$dependencies, styleEditorDependencies())

  position <- match.arg(position)

  options <- leaflet::filterNULL(list(
    position = position,
    openOnLeafletDraw = openOnLeafletDraw,
    useGrouping = useGrouping,
    ...
  ))
  leaflet::invokeMethod(map, leaflet::getMapData(map), 'addStyleEditor', options)
}

#' Remove style editor
#' @rdname style-editor
#' @export
removeStyleEditor <- function(map) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), 'removeStyleEditor')
}
