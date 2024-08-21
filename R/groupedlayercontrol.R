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
#' @seealso https://github.com/trafficonese/leaflet-groupedlayercontrol/
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

#' Options for the grouped layercontrol
#' @param exclusiveGroups character vector of layer groups to make exclusive (use radio buttons)
#' @param groupCheckboxes Show a checkbox next to non-exclusive group labels for toggling all
#' @param groupsCollapsable Should groups be collapsible? Default is \code{TRUE}
#' @param groupsExpandedClass The CSS class of expanded groups
#' @param groupsCollapsedClass The CSS class of collapsed groups
#' @param sortLayers Sort the overlay layers alphabetically? Default is \code{FALSE}
#' @param sortGroups Sort the groups alphabetically? Default is \code{FALSE}
#' @param sortBaseLayers Sort the baselayers alphabetically? Default is \code{FALSE}
#' @inheritParams leaflet::layersControlOptions
#' @rdname groupedlayercontrol
#' @export
groupedLayersControlOptions <- function(exclusiveGroups = NULL,
                                        groupCheckboxes = TRUE,
                                        groupsCollapsable = TRUE,
                                        groupsExpandedClass = "leaflet-control-layers-group-collapse-default",
                                        groupsCollapsedClass = "leaflet-control-layers-group-expand-default",
                                        sortLayers = FALSE,
                                        sortGroups = FALSE,
                                        sortBaseLayers = FALSE,
                                        collapsed = TRUE,
                                        autoZIndex = TRUE,
                                        ...) {

  filterNULL(list(exclusiveGroups = exclusiveGroups,
                  groupCheckboxes = groupCheckboxes,
                  groupsCollapsable = groupsCollapsable,
                  groupsExpandedClass = groupsExpandedClass,
                  groupsCollapsedClass = groupsCollapsedClass,
                  sortLayers = sortLayers,
                  sortGroups = sortGroups,
                  sortBaseLayers = sortBaseLayers,
                  collapsed = collapsed,
                  autoZIndex = autoZIndex,
                  ...))
}

#' Add an overlay layer to the layerscontrol
#' @inheritParams leaflet::removeLayersControl
#' @param group The group of the layer
#' @param name The name of the layer
#' @param groupname The groupname of the layer
#' @rdname groupedlayercontrol
#' @export
addGroupedOverlay <- function(map, group, name, groupname) {
  invokeMethod(map, NULL, "addGroupedOverlay",
               group, name, groupname)
}

#' Add a base layer to the layerscontrol
#' @inheritParams leaflet::removeLayersControl
#' @param group The group of the layer
#' @param name The name of the layer
#' @rdname groupedlayercontrol
#' @export
addGroupedBaseLayer <- function(map, group, name) {
  invokeMethod(map, NULL, "addGroupedBaseLayer",
               group, name)
}

#' Remove an overlay layer from the layerscontrol
#' @inheritParams leaflet::removeLayersControl
#' @param group The group of the layer
#' @rdname groupedlayercontrol
#' @export
removeGroupedOverlay <- function(map, group) {
  invokeMethod(map, NULL, "removeGroupedOverlay", group)
}

#' Removes the grouped layercontrol
#' @inheritParams leaflet::removeLayersControl
#' @rdname groupedlayercontrol
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
