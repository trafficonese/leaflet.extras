# Source https://github.com/kartoza/leaflet-wms-legend
wms.legendDependency <- function() {
  list(
    html_dep_prod("lfx-wms-legend", "0.0.1", has_style = TRUE, has_binding = TRUE)
  )
}

#' Add WMS Legend
#' @description Add a WMS Legend
#' @param uri The legend URI
#' @inheritParams leaflet::addLegend
#' @param layerId When the layerId of the WMS layer is properly set, the legend
#'   will appear or disappear accordingly based on whether the layer is visible or not.
#'   If no layerId is given, it will try to get the layer name from the `uri`,
#'   otherwise a random ID will be assigned.
#' @param title A title that is prepended before the image.
#' @param titleClass CSS-class for the title div
#' @param titleStyle Style the title with CSS
#' @param group The group argument is not used. Please set the `layerId` correctly.
#' @rdname wms-legend
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(11, 51, 6) %>%
#'   addWMSTiles(
#'     baseUrl = "https://www.wms.nrw.de/wms/unfallatlas?request=GetMap",
#'     layers = c("Unfallorte", "Personenschaden_5000", "Personenschaden_250"),
#'     options = WMSTileOptions(format = "image/png", transparent = TRUE)
#'   ) %>%
#'   addWMSLegend(
#'     title = "Personenschaden_5000", titleStyle = "font-size:1em; font-weight:800",
#'     uri = paste0(
#'       "https://www.wms.nrw.de/wms/unfallatlas?request=",
#'       "GetLegendGraphic&version=1.3.0&",
#'       "format=image/png&layer=Personenschaden_5000"
#'     )
#'   )
addWMSLegend <- function(map, uri, position = "topright", layerId = NULL, group = NULL,
                         title = "", titleClass = "wms-legend-title", titleStyle = "") {
  map$dependencies <- c(map$dependencies, wms.legendDependency())
  options <- leaflet::filterNULL(list(
    layerId = layerId,
    group = group,
    options = list(uri = uri, position = position),
    title = title,
    titleClass = titleClass,
    titleStyle = titleStyle
  ))
  invokeMethod(map, getMapData(map), "addWMSLegend", options)
}
