library(leaflet.extras)

leaflet(
  options = leafletOptions(
    center = c(-33.95293, 20.82824),
    zoom = 14,
    minZoom = 5,
    maxZoom = 18,
    maxBounds = list(
      c(-33.91444, 20.75351),
      c(-33.98731, 20.90626)
    )
  )
) %>%
  #addTiles() %>%
  addWMSTiles(baseUrl = "http://maps.kartoza.com/web/?map=/web/Boosmansbos/Boosmansbos.qgs",
              layers = "Boosmansbos",
              options = WMSTileOptions(format = "image/png", transparent = TRUE),
              attribution = "(c)<a href=\"http://kartoza.com\">Kartoza.com</a> and <a href=\"http://www.ngi.gov.za/\">SA-NGI</a>")  %>%
  addWMSLegend(uri = "http://maps.kartoza.com/web/?map=/web/Boosmansbos/Boosmansbos.qgs&&SERVICE=WMS&VERSION=1.3.0&SLD_VERSION=1.1.0&REQUEST=GetLegendGraphic&FORMAT=image/jpeg&LAYER=Boosmansbos&STYLE=")
