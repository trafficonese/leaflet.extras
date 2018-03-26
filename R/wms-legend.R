# Source https://github.com/kartoza/leaflet-wms-legend
wms.legendDependency <- function() {
  list(
    # // napa kartoza/leaflet-wms-legend#0f59578:leaflet-wms-legend
    html_dep_prod("lfx-wms-legend", "0.0.1", has_style = TRUE)
  )
}

#' Add WMS Legend
#' @description Add a WMS Legend
#' @param map The leaflet map
#' @param uri The legend URI
#' @param position position of control: "topleft", "topright", "bottomleft", or "bottomright"
#' @param layerId A unique ID for the Legend
#' @rdname wms-legend
#' @export
#' @examples
#' leaflet(
#'   options = leafletOptions(
#'     center = c(-33.95293, 20.82824),
#'     zoom = 14,
#'     minZoom = 5,
#'     maxZoom = 18,
#'     maxBounds = list(
#'       c(-33.91444, 20.75351),
#'       c(-33.98731, 20.90626)
#'     )
#'   )
#' ) %>%
#'   addWMSTiles(
#'     baseUrl = paste0(
#'       "http://maps.kartoza.com/web/?",
#'       "map=/web/Boosmansbos/Boosmansbos.qgs"
#'     ),
#'     layers = "Boosmansbos",
#'     options = WMSTileOptions(format = "image/png", transparent = TRUE),
#'     attribution = paste0(
#'       "(c)<a href= \"http://kartoza.com\">Kartoza.com</a> and ",
#'       "<a href= \"http://www.ngi.gov.za/\">SA-NGI</a>"
#'     )
#'   ) %>%
#'   addWMSLegend(
#'     uri = paste0(
#'       "http://maps.kartoza.com/web/?",
#'       "map=/web/Boosmansbos/Boosmansbos.qgs&&SERVICE=WMS&VERSION=1.3.0",
#'       "&SLD_VERSION=1.1.0&REQUEST=GetLegendGraphic&FORMAT=image/jpeg&LAYER=Boosmansbos&STYLE="
#'     )
#'   )
addWMSLegend <- function(map, uri, position = "topright", layerId = NULL) {
  map$dependencies <- c(map$dependencies, wms.legendDependency())
  options = leaflet::filterNULL(list(layerId = layerId,
                                     options = list(uri = uri, position = position)))
  htmlwidgets::onRender(
                        map,
                        JS("function(el,x,data){
                              var map = this;
                              var wmsLegendControl = new L.Control.WMSLegend(data.options);
                              if (data.layerId) {
                                map.controls.add(wmsLegendControl);
                              } else {
                                map.controls.add(wmsLegendControl, data.layerId);
                              }
                            }"),
                        options)
}
