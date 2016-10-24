# Source https://github.com/kartoza/leaflet-wms-legend
wms.legendDependency <- function() {
  list(
    htmltools::htmlDependency(
      "wms-legend",version = "0.0.1",
      system.file("htmlwidgets/lib/wms-legend", package = "leaflet.extras"),
      script = c("leaflet.wmslegend.js"),
      stylesheet = c("leaflet.wmslegend.css")

    )
  )
}

#' Add WMS Legend
#' @description Add a WMS Legend
#' @param map The leaflet map
#' @param uri The legend URI
#' @param position position of control: 'topleft', 'topright', 'bottomleft', or 'bottomright'
#' @param layerId A unique ID for the Legend
#' @rdname wms-legend
#' @export
addWMSLegend <- function(map, uri, position = 'topright', layerId = NULL) {
  map$dependencies <- c(map$dependencies, wms.legendDependency())
  options = leaflet::filterNULL(list(layerId = layerId,
                                     options=list(uri=uri, position=position)))
  htmlwidgets::onRender(
                        map,
                        JS("function(el,x,data){
                              var map = this;
                              var wmsLegendControl = new L.Control.WMSLegend(data.options);
                              if(data.layerId) {
                                map.controls.add(wmsLegendControl);
                              } else {
                                map.controls.add(wmsLegendControl, data.layerId);
                              }
                            }"),
                        options)
}
