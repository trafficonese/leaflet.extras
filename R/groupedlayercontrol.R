groupedlayersControlDependencies <- function() {
    list(
      html_dep_prod("lfx-groupedlayercontrol", "0.6.1", has_style = TRUE, has_binding = TRUE)
    )
}

#' Leaflet layer control with support for grouping overlays together.
#' Also supports making groups exclusive (radio instead of checkbox).
#' @param map The map widget.
#' @inheritParams leaflet::addLayersControl
#' @rdname groupedlayercontrol
#' @export
addGroupedLayersControl <- function(
    map,
    baseGroups = character(0),
    overlayGroups = character(0),
    position = c("topright", "bottomright", "bottomleft", "topleft"),
    options = groupedLayersControlOptions(),
    data = getMapData(map)) {

  map$dependencies <- c(map$dependencies, groupedlayersControlDependencies())
  options <- c(options, list(position = match.arg(position)))

  groupedOverlayGroups <- transform_groupedoverlays(overlayGroups)
  leaflet::invokeMethod(map, data, "addGroupedLayersControl",
                        baseGroups, groupedOverlayGroups,
                        options)
}
# addLayersControl()

#' Options for the grouped layercontrol
#' @param exclusiveGroups character vector of layer groups to make exclusive (use radio buttons)
#' @param groupCheckboxes Show a checkbox next to non-exclusive group labels for toggling all
#' @inheritParams leaflet::layersControlOptions
#' @rdname groupedlayercontrol
#' @seealso https://github.com/ismyrnow/leaflet-groupedlayercontrol
#' @export
groupedLayersControlOptions <- function(exclusiveGroups = NULL, groupCheckboxes = TRUE,
                                        collapsed = TRUE, autoZIndex = TRUE, ...) {
  filterNULL(list(exclusiveGroups = exclusiveGroups,
                  groupCheckboxes = groupCheckboxes,
                  collapsed = collapsed,
                  autoZIndex = autoZIndex,
                  ...))
}

#' Removes the grouped layercontrol
#' @inheritParams leaflet::removeLayersControl
#' @param group The group of the layer
#' @param name The name of the layer
#' @param group The groupname of the layer
#' @rdname groupedlayercontrol
#' @export
addGroupedOverlay <- function(map, group, name, groupname) {
  invokeMethod(map, NULL, "addGroupedOverlay",
               group, name, groupname)
}

#' Removes the grouped layercontrol
#' @inheritParams leaflet::removeLayersControl
#' @rdname draw
#' @export
removeGroupedLayersControl <- function(map) {
  invokeMethod(map, NULL, "removeGroupedLayersControl")
}

transform_groupedoverlays <- function(lst) {
  if (!is.list(lst)) lst <- as.list(lst)
  lapply(lst, function(x) {
    if (is.null(names(x))) {
      # If no names, use the layer names as keys
      setNames(as.list(x), x)
    } else {
      # If names exist, use them
      sapply(x, function(y) y, USE.NAMES = TRUE, simplify = TRUE)
    }
  })
}
# transform_groupedoverlays(c("Markers1","Markers2","Markers3"))
# transform_groupedoverlays(list("Markers1+2" = c("Markers1","Markers2"),
#                                "Markers3" = "Markers3"))
