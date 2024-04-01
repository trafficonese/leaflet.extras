library(leaflet.extras)

leaflet(
  options = leafletOptions(
    center = c(51, 11),
    zoom = 6,
    minZoom = 5,
    maxZoom = 18
  )
) %>%
  addTiles() %>%
  addWMSTiles(
    baseUrl = "https://www.wms.nrw.de/wms/unfallatlas?request=GetMap",
    layers = c("Unfallorte", "Personenschaden_5000", "Personenschaden_250"),
    options = WMSTileOptions(format = "image/png", transparent = TRUE)
  ) %>%
  addWMSLegend(
    uri = paste0(
      "https://www.wms.nrw.de/wms/unfallatlas?request=",
      "GetLegendGraphic&version=1.3.0&",
      "format=image/png&layer=Personenschaden_5000"
    )
  )
