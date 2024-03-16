styleEditorDependencies <- function() {
  list(
    html_dep_prod("lfx-styleeditor", "0.1.6", has_style = TRUE, has_binding = TRUE)
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
#' @examples
#' leaflet() %>%
#'   setView(0, 0, 2) %>%
#'   addProviderTiles(providers$CartoDB.Positron) %>%
#'   addDrawToolbar(
#'     targetGroup = "draw",
#'     editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
#'   ) %>%
#'   addLayersControl(
#'     overlayGroups = c("draw"), options = layersControlOptions(collapsed = FALSE)
#'   ) %>%
#'   # add the style editor to alter shapes added to map
#'   addStyleEditor()
addStyleEditor <- function(
    map,
    position = c("topleft", "topright", "bottomleft", "bottomright"),
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
  leaflet::invokeMethod(map, leaflet::getMapData(map), "addStyleEditor", options)
}

#' Remove style editor
#' @rdname style-editor
#' @export
removeStyleEditor <- function(map) {
  leaflet::invokeMethod(map, leaflet::getMapData(map), "removeStyleEditor")
}
