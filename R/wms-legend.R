# Source https://github.com/kartoza/leaflet-wms-legend
wms.legendDependency <- function() {
  list(
    # // napa kartoza/leaflet-wms-legend#0f59578:leaflet-wms-legend
    html_dep_prod("lfx-wms-legend", "0.0.1", has_style = TRUE, has_binding = TRUE)
  )
}

#' Add WMS Legend
#' @description Add a WMS Legend
#' @param uri The legend URI
#' @inheritParams leaflet::addLegend
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
#'     uri = paste0(
#'       "https://www.wms.nrw.de/wms/unfallatlas?request=",
#'       "GetLegendGraphic&version=1.3.0&",
#'       "format=image/png&layer=Personenschaden_5000"
#'     )
#'   )
addWMSLegend <- function(map, uri, position = "topright", layerId = NULL, group = NULL) {
  map$dependencies <- c(map$dependencies, wms.legendDependency())
  options <- leaflet::filterNULL(list(
    layerId = layerId,
    group = group,
    options = list(uri = uri, position = position)
  ))

  invokeMethod(map, getMapData(map), "addWMSLegend", options)
}
