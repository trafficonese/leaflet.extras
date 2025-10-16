groupedlayersControlDependencies <- function() {
  list(
    html_dep_prod("lfx-groupedlayercontrol", "0.6.1", has_style = TRUE, has_binding = TRUE)
  )
}

#' @title Leaflet layer control with support for grouping overlays together.
#' @description Also supports making groups exclusive (using radio inputs instead of checkbox).
#' See the JavaScript plugin for more information
#' \url{https://github.com/trafficonese/leaflet-groupedlayercontrol/}
#' @param overlayGroups A list of named vectors where each element is the name
#' of a group.
#' @param options a list of additional options, intended to be provided by a
#' call to \code{\link{groupedLayersControlOptions}}
#' @inheritParams leaflet::addLayersControl
#' @family GroupedLayersControl
#' @export
#' @examples
#' library(leaflet)
#' library(leaflet.extras)
#'
#' leaflet() %>%
#'   addTiles(group = "OpenStreetMap") %>%
#'   addProviderTiles("CartoDB", group = "CartoDB") %>%
#'   addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
#'     color = "red", group = "Markers2"
#'   ) %>%
#'   addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
#'     color = "green", group = "Markers1"
#'   ) %>%
#'   addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
#'     color = "yellow", group = "Markers3"
#'   ) %>%
#'   addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
#'     color = "lightblue", group = "Markers4"
#'   ) %>%
#'   addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
#'     color = "purple", group = "Markers5"
#'   ) %>%
#'   addGroupedLayersControl(
#'     baseGroups = c("OpenStreetMap", "CartoDB"),
#'     overlayGroups = list(
#'       "Layergroup_2" = c("Markers5", "Markers4"),
#'       "Layergroup_1" = c("Markers2", "Markers1", "Markers3")
#'     ),
#'     position = "topright",
#'     options = groupedLayersControlOptions(
#'       groupCheckboxes = TRUE,
#'       collapsed = FALSE,
#'       groupsCollapsable = TRUE,
#'       sortLayers = FALSE,
#'       sortGroups = FALSE,
#'       sortBaseLayers = FALSE,
#'       exclusiveGroups = "Layergroup_1"
#'     )
#'   )
addGroupedLayersControl <- function(
  map,
  baseGroups = character(0),
  overlayGroups = character(0),
  position = c("topright", "bottomright", "bottomleft", "topleft"),
  options = groupedLayersControlOptions()
) {
  map$dependencies <- c(map$dependencies, groupedlayersControlDependencies())
  options <- c(options, list(position = match.arg(position)))

  groupedOverlayGroups <- transform_groupedoverlays(overlayGroups)
  leaflet::invokeMethod(
    map, NULL, "addGroupedLayersControl",
    baseGroups, groupedOverlayGroups,
    options
  )
}

#' Options for the GroupedLayersControl
#' @param exclusiveGroups character vector of layer groups to make exclusive (use radio buttons)
#' @param groupCheckboxes Show a checkbox next to non-exclusive group labels for toggling all
#' @param groupsCollapsable Should groups be collapsible? Default is \code{TRUE}
#' @param groupsCollapsed A logical, character string, or character vector:
#'   \itemize{
#'     \item \code{TRUE} (default): Collapses all groups.
#'     \item \code{FALSE}: No groups are collapsed.
#'     \item A string: Collapses a single group (e.g., \code{"Group 1"}).
#'     \item A vector of strings: Collapses multiple groups (e.g., \code{c("Group 1", "Group 2")}).
#'   }
#' @param groupsExpandedClass The CSS class of expanded groups
#' @param groupsCollapsedClass The CSS class of collapsed groups
#' @param sortLayers Sort the overlay layers alphabetically? Default is \code{FALSE}
#' @param sortGroups Sort the groups alphabetically? Default is \code{FALSE}
#' @param sortBaseLayers Sort the baselayers alphabetically? Default is \code{FALSE}
#' @inheritParams leaflet::layersControlOptions
#' @family GroupedLayersControl
#' @export
groupedLayersControlOptions <- function(exclusiveGroups = NULL,
                                        groupCheckboxes = TRUE,
                                        groupsCollapsable = TRUE,
                                        groupsCollapsed = TRUE,
                                        groupsExpandedClass = "leaflet-control-layers-group-collapse-default",
                                        groupsCollapsedClass = "leaflet-control-layers-group-expand-default",
                                        sortLayers = FALSE,
                                        sortGroups = FALSE,
                                        sortBaseLayers = FALSE,
                                        collapsed = TRUE,
                                        autoZIndex = TRUE,
                                        ...) {
  filterNULL(list(
    exclusiveGroups = exclusiveGroups,
    groupCheckboxes = groupCheckboxes,
    groupsCollapsable = groupsCollapsable,
    groupsCollapsed = groupsCollapsed,
    groupsExpandedClass = groupsExpandedClass,
    groupsCollapsedClass = groupsCollapsedClass,
    sortLayers = sortLayers,
    sortGroups = sortGroups,
    sortBaseLayers = sortBaseLayers,
    collapsed = collapsed,
    autoZIndex = autoZIndex,
    ...
  ))
}


#' Methods of GroupedLayersControl
#' @description Add an overlay to the GroupedLayersControl
#' @param map The map widget
#' @param group The group of the leaflet layer
#' @param name The visible name of the layer in the control
#' @param groupname The visible group name in the control
#' @family GroupedLayersControl
#' @rdname GroupedLayersControl
#' @export
addGroupedOverlay <- function(map, group, name, groupname) {
  invokeMethod(
    map, NULL, "addGroupedOverlay",
    group, name, groupname
  )
}

#' @description Add a baselayer to the GroupedLayersControl
#' @rdname GroupedLayersControl
#' @export
addGroupedBaseLayer <- function(map, group, name) {
  invokeMethod(
    map, NULL, "addGroupedBaseLayer",
    group, name
  )
}

#' @description Remove an overlay layer from the GroupedLayersControl
#' @rdname GroupedLayersControl
#' @export
removeGroupedOverlay <- function(map, group) {
  invokeMethod(map, NULL, "removeGroupedOverlay", group)
}

#' @description Removes the GroupedLayersControl from the map
#' @rdname GroupedLayersControl
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
