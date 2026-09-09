# Add WMS Legend

Add a WMS Legend

## Usage

``` r
addWMSLegend(
  map,
  uri,
  position = "topright",
  layerId = NULL,
  group = NULL,
  title = "",
  titleClass = "wms-legend-title",
  titleStyle = ""
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- uri:

  The legend URI

- position:

  the position of the legend

- layerId:

  When the layerId of the WMS layer is properly set, the legend will
  appear or disappear accordingly based on whether the layer is visible
  or not. If no layerId is given, it will try to get the layer name from
  the \`uri\`, otherwise a random ID will be assigned.

- group:

  The group argument is not used. Please set the \`layerId\` correctly.

- title:

  A title that is prepended before the image.

- titleClass:

  CSS-class for the title div

- titleStyle:

  Style the title with CSS

## Examples

``` r
leaflet() %>%
  addTiles() %>%
  setView(11, 51, 6) %>%
  addWMSTiles(
    baseUrl = "https://www.wms.nrw.de/wms/unfallatlas?request=GetMap",
    layers = c("Unfallorte", "Personenschaden_5000", "Personenschaden_250"),
    options = WMSTileOptions(format = "image/png", transparent = TRUE)
  ) %>%
  addWMSLegend(
    title = "Personenschaden_5000", titleStyle = "font-size:1em; font-weight:800",
    uri = paste0(
      "https://www.wms.nrw.de/wms/unfallatlas?request=",
      "GetLegendGraphic&version=1.3.0&",
      "format=image/png&layer=Personenschaden_5000"
    )
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addWMSTiles","args":["https://www.wms.nrw.de/wms/unfallatlas?request=GetMap",null,null,{"styles":"","format":"image/png","transparent":true,"version":"1.1.1","layers":["Unfallorte","Personenschaden_5000","Personenschaden_250"]}]},{"method":"addWMSLegend","args":[{"options":{"uri":"https://www.wms.nrw.de/wms/unfallatlas?request=GetLegendGraphic&version=1.3.0&format=image/png&layer=Personenschaden_5000","position":"topright"},"title":"Personenschaden_5000","titleClass":"wms-legend-title","titleStyle":"font-size:1em; font-weight:800"}]}],"setView":[[51,11],6,[]]},"evals":[],"jsHooks":[]}
```
