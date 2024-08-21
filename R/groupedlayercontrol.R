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
    options = leaflet::layersControlOptions(),
    data = getMapData(map)) {

  map$dependencies <- c(map$dependencies, groupedlayersControlDependencies())
  options <- c(options, list(position = match.arg(position)))
  leaflet::invokeMethod(map, data, "addGroupedLayersControl",
                        baseGroups, overlayGroups,
                        options)
}

# addLayersControl()

#' Removes the grouped layercontrol
#' @inheritParams leaflet::removeLayersControl
#' @param layer The layerId of the layer to add
#' @param name The name of the layer
#' @param group The correspondng group of the layer
#' @rdname draw
#' @export
addGroupedOverlay <- function(map, layer, name, group) {
  invokeMethod(map, NULL, "addGroupedOverlay",
               layer, name, group)
}

#' Removes the grouped layercontrol
#' @inheritParams leaflet::removeLayersControl
#' @rdname draw
#' @export
removeGroupedLayersControl <- function(map) {
  invokeMethod(map, NULL, "removeGroupedLayersControl")
}
