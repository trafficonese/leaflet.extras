# Converts GeoJSON Feature properties to HTML

Converts GeoJSON Feature properties to HTML

Converts GeoJSON Feature properties to HTML Table.

Customize the leaflet widget style

## Usage

``` r
propsToHTML(props, elem = NULL, elem.attrs = NULL)

propstoHTMLTable(props = NULL, table.attrs = NULL, drop.na = TRUE)

setMapWidgetStyle(map, style = list(background = "transparent"))
```

## Arguments

- props:

  A list of GeoJSON Property Keys.

- elem:

  An optional wrapping element e.g. "div".

- elem.attrs:

  An optional named list for the wrapper element properties.

- table.attrs:

  An optional named list for the HTML Table.

- drop.na:

  whether to skip properties with empty values.

- map:

  the map widget

- style:

  a A list of CSS key/value properties.

## Examples

``` r
# \donttest{
geoJson <- jsonlite::fromJSON(readr::read_file(
  paste0(
    "https://raw.githubusercontent.com/MinnPost/simple-map-d3",
    "/master/example-data/world-population.geo.json"
  )
))

world <- leaflet(
  options = leafletOptions(
    maxZoom = 5,
    crs = leafletCRS(
      crsClass = "L.Proj.CRS", code = "ESRI:53009",
      proj4def = "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs",
      resolutions = c(65536, 32768, 16384, 8192, 4096, 2048)
    )
  )
) %>%
  addGraticule(style = list(color = "#999", weight = 0.5, opacity = 1, fill = NA)) %>%
  addGraticule(sphere = TRUE, style = list(color = "#777", weight = 1, opacity = 0.25, fill = NA))

world

{"x":{"options":{"maxZoom":5,"crs":{"crsClass":"L.Proj.CRS","code":"ESRI:53009","proj4def":"+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs","projectedBounds":null,"options":{"resolutions":[65536,32768,16384,8192,4096,2048]}}},"calls":[{"method":"addGraticule","args":[20,false,{"color":"#999","weight":0.5,"opacity":1,"fill":null},null,null,{"interactive":false,"pointerEvents":"none","className":""}]},{"method":"addGraticule","args":[20,true,{"color":"#777","weight":1,"opacity":0.25,"fill":null},null,null,{"interactive":false,"pointerEvents":"none","className":""}]}]},"evals":[],"jsHooks":[]}
# change background to white
world %>%
  setMapWidgetStyle(list(background = "white"))

{"x":{"options":{"maxZoom":5,"crs":{"crsClass":"L.Proj.CRS","code":"ESRI:53009","proj4def":"+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs","projectedBounds":null,"options":{"resolutions":[65536,32768,16384,8192,4096,2048]}}},"calls":[{"method":"addGraticule","args":[20,false,{"color":"#999","weight":0.5,"opacity":1,"fill":null},null,null,{"interactive":false,"pointerEvents":"none","className":""}]},{"method":"addGraticule","args":[20,true,{"color":"#777","weight":1,"opacity":0.25,"fill":null},null,null,{"interactive":false,"pointerEvents":"none","className":""}]},{"method":"setMapWidgetStyle","args":[{"background":"white"}]}]},"evals":[],"jsHooks":[]}# }
```
