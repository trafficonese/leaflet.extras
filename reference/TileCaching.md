# Enables caching of Tiles

Enables caching of tiles locally in browser. See
<https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached> for
details. In addition to invoking this function, you should also pass
`useCache=TRUE` & `crossOrigin=TRUE` in the
[`tileOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
call and pass that to your
[`addTiles`](https://rstudio.github.io/leaflet/reference/map-layers.html)'s
`options` parameter.

## Usage

``` r
enableTileCaching(map)
```

## Arguments

- map:

  The leaflet map

## Examples

``` r
leaflet() %>%
  enableTileCaching() %>%
  addTiles(options = tileOptions(useCache = TRUE, crossOrigin = TRUE))

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"useCache":true,"crossOrigin":true,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]}]},"evals":[],"jsHooks":[]}
## for more examples see
# browseURL(system.file("examples/TileLayer-Caching.R", package = "leaflet.extras"))
```
